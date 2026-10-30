import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../../models/expense_model.dart';

class ExpenseLocalDataSource {
  ExpenseLocalDataSource({required this.factory, this.databasePath});

  final DatabaseFactory factory;
  final String? databasePath;
  Future<Database>? _database;

  // Share the opening future so simultaneous requests open only one database.
  Future<Database> get database => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final resolvedPath =
        databasePath ??
        path.join(await factory.getDatabasesPath(), 'expense_tracker.db');

    return factory.openDatabase(
      resolvedPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
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
        },
      ),
    );
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final db = await database;
    final rows = await db.query('expenses', orderBy: 'date DESC');
    return rows.map(ExpenseModel.fromJson).toList();
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    return db.insert('expenses', expense.toJson());
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // The dependency container will own this source and call close on reset.
  Future<void> close() async {
    final pendingDatabase = _database;
    if (pendingDatabase != null) {
      final db = await pendingDatabase;
      await db.close();
      _database = null;
    }
  }
}
