import 'dart:io';

import 'package:fleet_wise_user_app/data/datasources/local/expense_database_migrations.dart';
import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/data/datasources/local/category_local_data_source.dart';
import 'package:fleet_wise_user_app/data/repositories/category_repository_impl.dart';
import 'package:fleet_wise_user_app/data/repositories/expense_repository_impl.dart';
import 'package:fleet_wise_user_app/domain/entities/category_draft.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  late Directory folder;
  late String databasePath;
  late ExpenseLocalDataSource source;
  late CategoryRepositoryImpl categories;
  late ExpenseRepositoryImpl expenses;
  setUp(() async {
    folder = await Directory.systemTemp.createTemp('category_link_');
    databasePath = path.join(folder.path, 'expense.db');
    source = ExpenseLocalDataSource(
      factory: databaseFactoryFfi,
      databasePath: databasePath,
    );
    categories = CategoryRepositoryImpl(CategoryLocalDataSource(source));
    expenses = ExpenseRepositoryImpl(source);
  });
  tearDown(() async {
    await source.close();
    await folder.delete(recursive: true);
  });

  Future<TransactionCategory> create(String name, {bool income = false}) async {
    final id = await categories.saveCategory(
      CategoryDraft(
        name: name,
        icon: CategoryIcon.home,
        color: CategoryColor.indigo,
        isIncome: income,
      ),
    );
    return (await categories.getCategories()).singleWhere(
      (row) => row.id == id,
    );
  }

  Expense row(TransactionCategory category, int amount) => Expense(
    title: 'Original transaction',
    amountMinor: amount,
    currencyCode: 'BDT',
    date: DateTime(2026),
    category: category,
    isIncome: category.isIncome,
  );

  test('custom expense/income categories persist; metadata edits update history without changing money or identity', () async {
    final rent = await create('Rent');
    final salary = await create('Consulting', income: true);
    await expenses.insertExpense(row(rent, 10));
    await expenses.insertExpense(row(rent, 20));
    await expenses.insertExpense(row(salary, 30));
    final before = await (await source.database).query(
      'expenses',
      orderBy: 'id',
    );
    expect(
      before.every(
        (record) => record['category'] == null && record['categoryId'] != null,
      ),
      isTrue,
    );
    await categories.saveCategory(
      CategoryDraft(
        id: rent.id,
        name: 'Monthly rent',
        icon: CategoryIcon.bills,
        color: CategoryColor.teal,
        isIncome: false,
      ),
    );
    await source.close();
    final restored = await expenses.getExpenses();
    final rents = restored
        .where((record) => record.category.id == rent.id)
        .toList();
    expect(rents, hasLength(2));
    expect(
      rents.every(
        (record) =>
            record.category.name == 'Monthly rent' &&
            record.category.icon == CategoryIcon.bills &&
            record.category.color == CategoryColor.teal,
      ),
      isTrue,
    );
    final summary = ExpenseSummary(restored, currencyCode: 'BDT');
    expect(summary.balanceMinor, BigInt.zero);
    expect(summary.categoryTotalsMinor.length, 1);
    expect(summary.categoryTotalsMinor[rent], BigInt.from(30));
    expect(
      await (await source.database).query('expenses', orderBy: 'id'),
      before,
    );
  });

  test('archive hides new choices, preserves old history and separates reused names by ID', () async {
    final old = await create('Rent');
    await expenses.insertExpense(row(old, 29));
    await categories.setArchived(old.id, true);
    expect(
      (await categories.getCategories()).any((record) => record.id == old.id),
      isFalse,
    );
    final history = (await expenses.getExpenses()).single;
    expect(history.category.id, old.id);
    expect(history.category.isArchived, isTrue);
    await expectLater(
      expenses.insertExpense(row(old, 1)),
      throwsA(
        isA<CategoryException>().having(
          (e) => e.problem,
          'problem',
          CategoryProblem.archived,
        ),
      ),
    );
    final replacement = await create('Rent');
    expect(replacement.id, isNot(old.id));
    await expenses.insertExpense(row(replacement, 1));
    final summary = ExpenseSummary(
      await expenses.getExpenses(),
      currencyCode: 'BDT',
    );
    expect(summary.categoryTotalsMinor, {
      old: BigInt.from(29),
      replacement: BigInt.one,
    });
    expect(summary.totalExpenseMinor, BigInt.from(30));
  });

  test(
    'wrong type and missing references are rejected, including SQL bypasses',
    () async {
      final rent = await create('Rent');
      await expectLater(
        expenses.insertExpense(
          Expense(
            title: 'Wrong',
            amountMinor: 1,
            date: DateTime(2026),
            category: rent,
            isIncome: true,
          ),
        ),
        throwsA(isA<CategoryException>()),
      );
      final missing = TransactionCategory(
        id: 'missing',
        name: 'Missing',
        icon: CategoryIcon.home,
        color: CategoryColor.teal,
        isIncome: false,
      );
      await expectLater(
        expenses.insertExpense(row(missing, 1)),
        throwsA(isA<CategoryException>()),
      );
      final db = await source.database;
      await expectLater(
        db.insert('expenses', {
          'categoryId': 'missing',
          'syncId': 'invalid-reference',
        }),
        throwsA(isA<DatabaseException>()),
      );
      await expectLater(
        db.insert('expenses', {'syncId': 'null-reference'}),
        throwsA(isA<DatabaseException>()),
      );
      await expenses.insertExpense(row(rent, 1));
      await expectLater(
        db.delete('categories', where: 'id = ?', whereArgs: [rent.id]),
        throwsA(isA<DatabaseException>()),
      );
      expect(await expenses.getExpenses(), hasLength(1));
    },
  );

  test('v5 maps all historical indices to stable IDs even when defaults are renamed or archived', () async {
    final migrations = ExpenseDatabaseMigrations(createSyncId: () => 'unused');
    final legacy = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(version: 5, onCreate: migrations.create),
    );
    for (var index = 0; index < 7; index++) {
      await legacy.insert('expenses', {
        'id': index + 1,
        'syncId': 'old-$index',
        'title': 'Keep $index',
        'amount': index + .125,
        'amountMinor': index + 1,
        'category': index,
        'isIncome': 1,
        'currencyCode': 'USD',
        'date': '2026-01-01',
      });
    }
    await legacy.update('categories', {
      'name': 'Meals',
      'normalizedName': 'meals',
      'builtInKey': null,
      'isArchived': 1,
    }, where: "id = 'default-food'");
    final before = await legacy.query('expenses', orderBy: 'id');
    final categoryBefore = await legacy.query('categories', orderBy: 'id');
    await legacy.close();
    final upgraded = await source.database;
    final after = await upgraded.query('expenses', orderBy: 'id');
    expect(after.map((record) => record['categoryId']), [
      'default-food',
      'default-transport',
      'default-entertainment',
      'default-shopping',
      'default-health',
      'default-others',
      'default-income',
    ]);
    expect(
      after.map(
        (record) => Map<String, Object?>.from(record)..remove('categoryId'),
      ),
      before,
    );
    expect(await upgraded.query('categories', orderBy: 'id'), categoryBefore);
    expect((await expenses.getExpenses()).last.category.name, 'Meals');
    expect((await expenses.getExpenses()).last.category.isArchived, isTrue);
    await source.close();
    expect(
      await (await source.database).query('expenses', orderBy: 'id'),
      after,
    );
    expect(
      await (await source.database).rawQuery('PRAGMA foreign_key_check'),
      isEmpty,
    );
  });

  test('invalid legacy index rolls back the full link migration and permits repair/retry', () async {
    final migrations = ExpenseDatabaseMigrations(createSyncId: () => 'unused');
    final legacy = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(version: 5, onCreate: migrations.create),
    );
    await legacy.insert('expenses', {
      'id': 42,
      'syncId': 'keep',
      'title': 'Keep',
      'amountMinor': 29,
      'category': 99,
      'isIncome': 0,
      'date': '2026-01-01',
      'currencyCode': 'BDT',
    });
    final before = await legacy.query('expenses');
    await legacy.close();
    await expectLater(source.database, throwsA(isA<FormatException>()));
    final unchanged = await databaseFactoryFfi.openDatabase(databasePath);
    expect(await unchanged.getVersion(), 5);
    expect(await unchanged.query('expenses'), before);
    expect(
      (await unchanged.rawQuery('PRAGMA table_info(expenses)'))
          .map((record) => record['name']),
      isNot(contains('categoryId')),
    );
    await unchanged.update('expenses', {'category': 0}, where: 'id = 42');
    await unchanged.close();
    expect((await expenses.getExpenses()).single.category.id, 'default-food');
    expect(await (await source.database).getVersion(), 6);
  });
}
