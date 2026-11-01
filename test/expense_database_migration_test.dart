import 'dart:io';

import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/data/datasources/local/expense_database_migrations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> createLegacyDatabase(String databasePath) async {
  final db = await databaseFactoryFfi.openDatabase(
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
  for (final id in [1, 42, 100]) {
    await db.insert('expenses', {
      'id': id,
      'title': 'Original $id',
      'amount': id == 1 ? -12.345 : 30000.0,
      'date': '2026-04-09T12:30:00.123456',
      'category': id == 1 ? 0 : 6,
      'isIncome': id == 1 ? 0 : 1,
    });
  }
  await db.delete('expenses', where: 'id = ?', whereArgs: [100]);
  await db.close();
}

void main() {
  sqfliteFfiInit();
  late Directory directory;
  late String databasePath;
  late ExpenseLocalDataSource source;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('expense_migration_');
    databasePath = path.join(directory.path, 'expense_tracker.db');
    await createLegacyDatabase(databasePath);
    source = ExpenseLocalDataSource(
      factory: databaseFactoryFfi,
      databasePath: databasePath,
    );
  });
  tearDown(() async {
    await source.close();
    await directory.delete(recursive: true);
  });

  test(
    'upgrade preserves values, local IDs and the deleted-ID sequence',
    () async {
      final db = await source.database;
      expect(await db.getVersion(), 6);
      final rows = await db.query('expenses', orderBy: 'id');
      expect(rows.map((row) => row['id']).toList(), [1, 42]);
      expect(rows.first['title'], 'Original 1');
      expect(rows.first['amount'], -12.345);
      expect(rows.first['amountMinor'], -1235);
      expect(rows.first['date'], '2026-04-09T12:30:00.123456');
      expect(rows.first['category'], 0);
      expect(rows.first['isIncome'], 0);
      expect(rows.every((row) => row['currencyCode'] == 'USD'), isTrue);
      expect(rows.last['amount'], 30000);
      expect(rows.last['amountMinor'], 3000000);
      expect(rows.last['category'], 6);
      expect(rows.last['isIncome'], 1);
      final syncIds = rows.map((row) => row['syncId']).toList();
      expect(syncIds.toSet(), hasLength(2));
      expect(syncIds, everyElement(isNot(isEmpty)));
      final newId = await db.insert('expenses', {
        'title': 'New',
        'amount': null,
        'amountMinor': 100,
        'date': '2026-04-10',
        'category': 0,
        'isIncome': 0,
        'syncId': 'new-stable-id',
        'categoryId': 'default-food',
      });
      expect(newId, greaterThan(100));
      await source.close();
      final reopened = await source.database;
      final reopenedRows = await reopened.query(
        'expenses',
        where: 'id <= 42',
        orderBy: 'id',
      );
      expect(reopenedRows.map((row) => row['syncId']).toList(), syncIds);
    },
  );

  test(
    'version 2 upgrade retains existing sync IDs and assigns legacy USD',
    () async {
      final version2 = await databaseFactoryFfi.openDatabase(
        databasePath,
        options: OpenDatabaseOptions(
          version: 2,
          onUpgrade: (db, oldVersion, newVersion) async {
            await db.execute(
              "ALTER TABLE expenses ADD COLUMN syncId TEXT NOT NULL DEFAULT ''",
            );
            await db.execute("UPDATE expenses SET syncId = 'saved-' || id");
            await db.execute(
              'CREATE UNIQUE INDEX expenses_sync_id ON expenses(syncId)',
            );
          },
        ),
      );
      await version2.close();
      final db = await source.database;
      expect(await db.getVersion(), 6);
      final rows = await db.query('expenses', orderBy: 'id');
      expect(rows.map((row) => row['syncId']).toList(), [
        'saved-1',
        'saved-42',
      ]);
      expect(rows.every((row) => row['currencyCode'] == 'USD'), isTrue);
    },
  );

  test(
    'failed upgrade rolls back data/schema and the same source can retry',
    () async {
      var failMigration = true;
      var nextId = 0;
      source = ExpenseLocalDataSource(
        factory: databaseFactoryFfi,
        databasePath: databasePath,
        createSyncId: () => failMigration ? 'duplicate' : 'stable-${nextId++}',
      );
      await expectLater(source.database, throwsA(isA<DatabaseException>()));
      final legacy = await databaseFactoryFfi.openDatabase(databasePath);
      expect(await legacy.getVersion(), 1);
      final columns = await legacy.rawQuery('PRAGMA table_info(expenses)');
      expect(
        columns.map((column) => column['name']),
        isNot(contains('syncId')),
      );
      final rows = await legacy.query('expenses', orderBy: 'id');
      expect(rows.map((row) => row['id']).toList(), [1, 42]);
      expect(rows.first['amount'], -12.345);
      await legacy.close();
      failMigration = false;
      final upgraded = await source.database;
      expect(await upgraded.getVersion(), 6);
      expect((await source.getExpenses()).map((row) => row.syncId).toSet(), {
        'stable-0',
        'stable-1',
      });
    },
  );
  test(
    'version 3 migration preserves raw amounts, currencies and sync IDs',
    () async {
      final migrations = ExpenseDatabaseMigrations(
        createSyncId: () => 'unused',
      );
      var nextId = 0;
      final version3 = await databaseFactoryFfi.openDatabase(
        databasePath,
        options: OpenDatabaseOptions(
          version: 3,
          onUpgrade: ExpenseDatabaseMigrations(
            createSyncId: () => 'old-${nextId++}',
          ).upgrade,
        ),
      );
      for (final amount in [0.1, 0.2, 0.29, 1.005, -0.005, 0.0]) {
        await version3.insert('expenses', {
          'title': 'Decimal $amount',
          'amount': amount,
          'date': '2026-04-09',
          'category': 0,
          'isIncome': 0,
          'currencyCode': 'BDT',
          'syncId': 'decimal-$amount',
        });
      }
      final before = await version3.query('expenses', orderBy: 'id');
      await version3.close();
      final db = await source.database;
      final after = await db.query('expenses', orderBy: 'id');
      for (var index = 0; index < before.length; index++) {
        final restored = Map<String, Object?>.from(after[index])
          ..remove('amountMinor')
          ..remove('categoryId');
        expect(restored, before[index]);
      }
      expect(after.map((row) => row['amountMinor']), [
        -1235,
        3000000,
        10,
        20,
        29,
        101,
        -1,
        0,
      ]);
      // Applying a migration again must not round integer amounts again.
      await migrations.upgrade(db, 4, 4);
      await source.close();
      expect(
        await (await source.database).query('expenses', orderBy: 'id'),
        after,
      );
    },
  );

  test('invalid version 3 amount rolls back the money migration and supports repair/retry', () async {
    var nextId = 0;
    final version3 = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 3,
        onUpgrade: ExpenseDatabaseMigrations(
          createSyncId: () => 'old-${nextId++}',
        ).upgrade,
      ),
    );
    await version3.update('expenses', {'amount': 1e100}, where: 'id = 42');
    final before = await version3.query('expenses', orderBy: 'id');
    await version3.close();
    await expectLater(source.database, throwsA(isA<FormatException>()));
    final unchanged = await databaseFactoryFfi.openDatabase(databasePath);
    expect(await unchanged.getVersion(), 3);
    expect(await unchanged.query('expenses', orderBy: 'id'), before);
    final columns = await unchanged.rawQuery('PRAGMA table_info(expenses)');
    expect(columns.map((row) => row['name']), isNot(contains('amountMinor')));
    await unchanged.update('expenses', {'amount': 30000.0}, where: 'id = 42');
    await unchanged.close();
    expect(await (await source.database).getVersion(), 6);
    expect((await source.getExpenses()).map((row) => row.amountMinor).toSet(), {
      -1235,
      3000000,
    });
  });
}
