import 'dart:io';

import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
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
      expect(await db.getVersion(), 2);
      final rows = await db.query('expenses', orderBy: 'id');
      expect(rows.map((row) => row['id']).toList(), [1, 42]);
      expect(rows.first['title'], 'Original 1');
      expect(rows.first['amount'], -12.345);
      expect(rows.first['date'], '2026-04-09T12:30:00.123456');
      expect(rows.first['category'], 0);
      expect(rows.first['isIncome'], 0);
      expect(rows.last['amount'], 30000);
      expect(rows.last['category'], 6);
      expect(rows.last['isIncome'], 1);
      final syncIds = rows.map((row) => row['syncId']).toList();
      expect(syncIds.toSet(), hasLength(2));
      expect(syncIds, everyElement(isNot(isEmpty)));
      final newId = await db.insert('expenses', {
        'title': 'New',
        'amount': 1.0,
        'date': '2026-04-10',
        'category': 0,
        'isIncome': 0,
        'syncId': 'new-stable-id',
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
      expect(await upgraded.getVersion(), 2);
      expect((await source.getExpenses()).map((row) => row.syncId).toSet(), {
        'stable-0',
        'stable-1',
      });
    },
  );
}
