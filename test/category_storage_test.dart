import 'dart:io';

import 'package:fleet_wise_user_app/data/datasources/local/category_local_data_source.dart';
import 'package:fleet_wise_user_app/data/datasources/local/expense_database_migrations.dart';
import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/data/repositories/category_repository_impl.dart';
import 'package:fleet_wise_user_app/domain/entities/category_draft.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

CategoryDraft draft(
  String name, {
  String? id,
  bool income = false,
  CategoryIcon icon = CategoryIcon.home,
  CategoryColor color = CategoryColor.teal,
}) => CategoryDraft(
  id: id,
  name: name,
  icon: icon,
  color: color,
  isIncome: income,
);

Matcher problem(CategoryProblem value) => throwsA(
  isA<CategoryException>().having((e) => e.problem, 'problem', value),
);

void main() {
  sqfliteFfiInit();
  late Directory directory;
  late String databasePath;
  late ExpenseLocalDataSource expenses;
  late CategoryRepositoryImpl repository;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('category_storage_');
    databasePath = path.join(directory.path, 'expense_tracker.db');
    expenses = ExpenseLocalDataSource(
      factory: databaseFactoryFfi,
      databasePath: databasePath,
    );
    repository = CategoryRepositoryImpl(CategoryLocalDataSource(expenses));
  });
  tearDown(() async {
    await expenses.close();
    await directory.delete(recursive: true);
  });

  test(
    'fresh database seeds seven defaults once with stable identities',
    () async {
      final initial = await repository.getCategories();
      expect(initial, hasLength(7));
      expect(initial.where((row) => row.isIncome).single.id, 'default-income');
      expect(initial.map((row) => row.builtInKey).toSet(), {
        'food',
        'transport',
        'entertainment',
        'shopping',
        'health',
        'others',
        'income',
      });
      expect(initial.every((row) => !row.isArchived), isTrue);
      await expenses.close();
      final reopened = await repository.getCategories();
      expect(reopened.map((row) => row.id), initial.map((row) => row.id));
    },
  );

  test(
    'create and edit preserve ID, trimmed name and icon/color across reopening',
    () async {
      final id = await repository.saveCategory(draft('  বাসা ভাড়া  '));
      expect(id, matches(RegExp(r'^[0-9a-f-]{36}$')));
      final created = (await repository.getCategories()).singleWhere(
        (row) => row.id == id,
      );
      expect(created.name, 'বাসা ভাড়া');
      expect(created.builtInKey, isNull);
      final edited = await repository.saveCategory(
        draft(
          'Monthly rent',
          id: id,
          icon: CategoryIcon.bills,
          color: CategoryColor.indigo,
        ),
      );
      expect(edited, id);
      await expenses.close();
      final restored = (await repository.getCategories()).singleWhere(
        (row) => row.id == id,
      );
      expect(restored.name, 'Monthly rent');
      expect(restored.icon, CategoryIcon.bills);
      expect(restored.color, CategoryColor.indigo);
    },
  );

  test('built-in translation is retained for styling edits and cleared for renaming', () async {
    await repository.saveCategory(
      draft('Food', id: 'default-food', color: CategoryColor.teal),
    );
    var food = (await repository.getCategories()).singleWhere(
      (row) => row.id == 'default-food',
    );
    expect(food.builtInKey, 'food');
    await repository.saveCategory(draft('Meals', id: food.id));
    food = (await repository.getCategories()).singleWhere(
      (row) => row.id == 'default-food',
    );
    expect(food.builtInKey, isNull);
    expect(food.name, 'Meals');
  });

  test('names are unique per active type after trimming, case and repeated-space normalization', () async {
    final id = await repository.saveCategory(draft('Side   work'));
    await expectLater(
      repository.saveCategory(draft(' side work ')),
      problem(CategoryProblem.duplicateName),
    );
    await expectLater(
      repository.saveCategory(draft('food')),
      problem(CategoryProblem.duplicateName),
    );
    await repository.saveCategory(draft('Side work', income: true));
    // Saving the same row with the same name is a valid edit.
    await repository.saveCategory(draft('Side   work', id: id));
    expect(await repository.getCategories(), hasLength(9));
  });

  test(
    'archive and restore retain rows; archived rows cannot be edited',
    () async {
      final id = await repository.saveCategory(draft('Rent'));
      await repository.setArchived(id, true);
      await repository.setArchived(id, true);
      expect(
        (await repository.getCategories()).any((row) => row.id == id),
        isFalse,
      );
      expect(
        (await repository.getCategories(includeArchived: true))
            .singleWhere((row) => row.id == id)
            .isArchived,
        isTrue,
      );
      await expectLater(
        repository.saveCategory(draft('New rent', id: id)),
        problem(CategoryProblem.archived),
      );
      await expenses.close();
      await repository.setArchived(id, false);
      expect(
        (await repository.getCategories())
            .singleWhere((row) => row.id == id)
            .name,
        'Rent',
      );
    },
  );

  test(
    'restore conflict leaves both old archived and new active rows intact',
    () async {
      final first = await repository.saveCategory(draft('Rent'));
      await repository.setArchived(first, true);
      final replacement = await repository.saveCategory(draft('RENT'));
      await expectLater(
        repository.setArchived(first, false),
        problem(CategoryProblem.duplicateName),
      );
      final rows = await repository.getCategories(includeArchived: true);
      expect(rows.singleWhere((row) => row.id == first).isArchived, isTrue);
      expect(
        rows.singleWhere((row) => row.id == replacement).isArchived,
        isFalse,
      );
    },
  );

  test(
    'type changes and missing edit/archive IDs fail without creating rows',
    () async {
      final id = await repository.saveCategory(draft('Rent'));
      await expectLater(
        repository.saveCategory(draft('Salary', id: id, income: true)),
        problem(CategoryProblem.typeChange),
      );
      await expectLater(
        repository.saveCategory(draft('Missing', id: 'missing')),
        problem(CategoryProblem.notFound),
      );
      await expectLater(
        repository.setArchived('missing', true),
        problem(CategoryProblem.notFound),
      );
      expect(await repository.getCategories(), hasLength(8));
    },
  );

  test(
    'invalid names cannot write even when repository is called directly',
    () async {
      for (final name in [
        '   ',
        List.filled(CategoryDraft.maxNameLength + 1, 'a').join(),
      ]) {
        await expectLater(
          repository.saveCategory(draft(name)),
          problem(CategoryProblem.invalidName),
        );
      }
      expect(await repository.getCategories(), hasLength(7));
    },
  );

  test('overlapping duplicate saves create only one category', () async {
    Future<Object> save(String name) async {
      try {
        return await repository.saveCategory(draft(name));
      } catch (error) {
        return error;
      }
    }

    final results = await Future.wait([save('Rent'), save('RENT')]);
    expect(results.whereType<String>(), hasLength(1));
    expect(
      results.whereType<CategoryException>().single.problem,
      CategoryProblem.duplicateName,
    );
    expect(await repository.getCategories(), hasLength(8));
  });

  test('v4 upgrade adds categories without changing any transaction columns or values', () async {
    final migrations = ExpenseDatabaseMigrations(createSyncId: () => 'unused');
    final old = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(version: 4, onCreate: migrations.create),
    );
    await old.insert('expenses', {
      'id': 42,
      'title': 'Original',
      'amount': -12.345,
      'amountMinor': -1235,
      'syncId': 'old-stable-id',
      'currencyCode': 'INR',
      'date': '2026-04-09',
      'category': 5,
      'isIncome': 0,
    });
    final before = await old.query('expenses');
    await old.close();
    final upgraded = await expenses.database;
    expect(await upgraded.getVersion(), 5);
    expect(await upgraded.query('expenses'), before);
    expect(await repository.getCategories(), hasLength(7));
    // Category mutations never touch transactions during this foundation step.
    await repository.saveCategory(draft('Different', id: 'default-others'));
    await repository.setArchived('default-others', true);
    expect(await upgraded.query('expenses'), before);
    expect(
      (await upgraded.rawQuery('PRAGMA integrity_check')).single.values.single,
      'ok',
    );
  });

  test(
    'failed category-table creation rolls back and retry preserves v4 data',
    () async {
      final migrations = ExpenseDatabaseMigrations(
        createSyncId: () => 'unused',
      );
      final old = await databaseFactoryFfi.openDatabase(
        databasePath,
        options: OpenDatabaseOptions(version: 4, onCreate: migrations.create),
      );
      await old.insert('expenses', {
        'id': 91,
        'title': 'Keep during failed upgrade',
        'amountMinor': 29,
        'syncId': 'original-id',
        'currencyCode': 'BDT',
        'date': '2026-04-09',
        'category': 0,
        'isIncome': 0,
      });
      final before = await old.query('expenses');
      await old.execute('CREATE TABLE categories (unrelated TEXT)');
      await old.close();
      await expectLater(expenses.database, throwsA(isA<DatabaseException>()));
      final unchanged = await databaseFactoryFfi.openDatabase(databasePath);
      expect(await unchanged.getVersion(), 4);
      expect(await unchanged.query('expenses'), before);
      await unchanged.execute('DROP TABLE categories');
      await unchanged.close();
      expect(await repository.getCategories(), hasLength(7));
      expect(await (await expenses.database).getVersion(), 5);
      expect(await (await expenses.database).query('expenses'), before);
    },
  );
}
