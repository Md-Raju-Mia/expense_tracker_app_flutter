import 'dart:io';

import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/data/mappers/expense_mapper.dart';
import 'package:fleet_wise_user_app/data/models/expense_model.dart';
import 'package:fleet_wise_user_app/data/repositories/expense_repository_impl.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Expense transaction(DateTime date, {double amount = 12.5}) {
  return Expense(
    title: 'Lunch',
    amount: amount,
    date: date,
    category: ExpenseCategory.food,
  );
}

void main() {
  sqfliteFfiInit();

  test('mapper preserves old row format and all category indices', () {
    for (final category in ExpenseCategory.values) {
      final original = Expense(
        id: 9,
        syncId: 'saved-transaction-id',
        title: '  unchanged  ',
        amount: -12.5,
        date: DateTime(2026, 4, 9, 14, 30, 15, 123, 456),
        category: category,
        isIncome: true,
      );
      final row = original.toModel().toJson();
      expect(row, {
        'id': 9,
        'syncId': 'saved-transaction-id',
        'title': '  unchanged  ',
        'amount': -12.5,
        'date': original.date.toIso8601String(),
        'category': category.index,
        'isIncome': 1,
      });
      final restored = ExpenseModel.fromJson(row).toEntity();
      expect(restored.date, original.date);
      expect(restored.syncId, original.syncId);
      expect(restored.category, category);
      expect(restored.isIncome, isTrue);
      expect(restored.amount, -12.5);
    }
  });

  group('SQLite storage', () {
    late Directory directory;
    late String databasePath;
    late ExpenseLocalDataSource source;
    late ExpenseRepositoryImpl repository;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('expense_storage_');
      databasePath = path.join(directory.path, 'expense_tracker.db');
      source = ExpenseLocalDataSource(
        factory: databaseFactoryFfi,
        databasePath: databasePath,
      );
      repository = ExpenseRepositoryImpl(source);
    });

    tearDown(() async {
      await source.close();
      await directory.delete(recursive: true);
    });

    test('creates version 2 schema and shares concurrent opening', () async {
      final databases = await Future.wait([source.database, source.database]);
      expect(identical(databases[0], databases[1]), isTrue);
      expect(await databases[0].getVersion(), 2);
      final columns = await databases[0].rawQuery(
        'PRAGMA table_info(expenses)',
      );
      expect(columns.map((column) => column['name']).toList(), [
        'id',
        'title',
        'amount',
        'date',
        'category',
        'isIncome',
        'syncId',
      ]);
      expect(await repository.getExpenses(), isEmpty);
    });

    test(
      'inserts, sorts by date descending, deletes only the requested row',
      () async {
        final older = transaction(DateTime(2026, 4, 8));
        final newer = transaction(DateTime(2026, 4, 9, 15, 20), amount: -5);
        final olderId = await repository.insertExpense(older);
        final newerId = await repository.insertExpense(newer);
        final rows = await repository.getExpenses();
        expect(rows.map((row) => row.id).toList(), [newerId, olderId]);
        expect(rows.first.date, newer.date);
        expect(rows.first.amount, -5);
        expect(rows.first.isIncome, isFalse);
        expect(await repository.deleteExpense(newerId), 1);
        expect(await repository.deleteExpense(newerId), 0);
        expect((await repository.getExpenses()).single.id, olderId);
        await repository.deleteExpense(olderId);
        expect(await repository.getExpenses(), isEmpty);
      },
    );

    test(
      'reads a legacy schema and persists writes across reopening',
      () async {
        // Create the database independently using the exact old table layout.
        final legacy = await databaseFactoryFfi.openDatabase(
          databasePath,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await db.execute(
                'CREATE TABLE expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT, category INTEGER, isIncome INTEGER)',
              );
            },
          ),
        );
        await legacy.insert('expenses', {
          'id': 42,
          'title': 'Salary',
          'amount': 30000,
          'date': '2026-04-09T12:30:00.000',
          'category': 6,
          'isIncome': 1,
        });
        await legacy.close();
        final salary = (await repository.getExpenses()).single;
        expect(salary.id, 42);
        expect(salary.amount, 30000);
        expect(salary.category, ExpenseCategory.income);
        expect(salary.isIncome, isTrue);
        final salarySyncId = salary.syncId;
        expect(
          salarySyncId,
          matches(
            RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            ),
          ),
        );
        final id = await repository.insertExpense(
          transaction(DateTime(2026, 4, 10)),
        );
        expect(id, greaterThan(42));
        await source.close();
        source = ExpenseLocalDataSource(
          factory: databaseFactoryFfi,
          databasePath: databasePath,
        );
        repository = ExpenseRepositoryImpl(source);
        expect((await repository.getExpenses()).map((row) => row.id).toList(), [
          id,
          42,
        ]);
        expect((await repository.getExpenses()).last.syncId, salarySyncId);
      },
    );

    test(
      'new rows get distinct stable UUIDs and supplied IDs are retained',
      () async {
        await repository.insertExpense(transaction(DateTime(2026, 4, 9)));
        await repository.insertExpense(transaction(DateTime(2026, 4, 10)));
        final rows = await repository.getExpenses();
        expect(rows.map((row) => row.syncId).toSet(), hasLength(2));
        for (final row in rows) {
          expect(
            row.syncId,
            matches(
              RegExp(
                r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
              ),
            ),
          );
        }
        final imported = Expense(
          syncId: 'f2d16538-1a90-4cba-8742-90125963bbaa',
          title: 'Imported',
          amount: 5,
          date: DateTime(2026, 4, 11),
          category: ExpenseCategory.food,
        );
        await repository.insertExpense(imported);
        expect((await repository.getExpenses()).first.syncId, imported.syncId);
        await expectLater(
          repository.insertExpense(imported),
          throwsA(isA<DatabaseException>()),
        );
        expect(await repository.getExpenses(), hasLength(3));
      },
    );
  });
}
