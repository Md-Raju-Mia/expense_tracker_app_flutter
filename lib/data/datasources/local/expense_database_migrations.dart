import 'package:sqflite/sqflite.dart';

class ExpenseDatabaseMigrations {
  ExpenseDatabaseMigrations({required this.createSyncId});

  static const version = 2;
  final String Function() createSyncId;

  Future<void> create(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        category INTEGER,
        isIncome INTEGER
      )
    ''');
    // Fresh installs and upgrades follow the same schema changes.
    await upgrade(db, 1, newVersion);
  }

  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute(
        "ALTER TABLE expenses ADD COLUMN syncId TEXT NOT NULL DEFAULT ''",
      );
      final rows = await db.query('expenses', columns: ['id']);
      for (final row in rows) {
        await db.update(
          'expenses',
          {'syncId': createSyncId()},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
      }
      await db.execute(
        'CREATE UNIQUE INDEX expenses_sync_id ON expenses(syncId)',
      );
    }
  }
}
