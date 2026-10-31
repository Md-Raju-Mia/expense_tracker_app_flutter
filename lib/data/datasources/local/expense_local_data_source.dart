import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../models/expense_model.dart';
import 'expense_database_migrations.dart';

String _newSyncId() => const Uuid().v4();

class ExpenseLocalDataSource {
  ExpenseLocalDataSource({
    required this.factory,
    this.databasePath,
    this.createSyncId = _newSyncId,
  });

  final DatabaseFactory factory;
  final String? databasePath;
  final String Function() createSyncId;
  Future<Database>? _database;

  // Share the opening future so simultaneous requests open only one database.
  Future<Database> get database => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final resolvedPath =
        databasePath ??
        path.join(await factory.getDatabasesPath(), 'expense_tracker.db');

    final migrations = ExpenseDatabaseMigrations(createSyncId: createSyncId);
    try {
      return await factory.openDatabase(
        resolvedPath,
        options: OpenDatabaseOptions(
          version: ExpenseDatabaseMigrations.version,
          onCreate: migrations.create,
          onUpgrade: migrations.upgrade,
        ),
      );
    } catch (_) {
      // A failed upgrade must be retryable after the underlying problem is fixed.
      _database = null;
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final db = await database;
    final rows = await db.query('expenses', orderBy: 'date DESC');
    return rows.map(ExpenseModel.fromJson).toList();
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    final savedExpense = expense.copyWith(
      syncId: expense.syncId ?? createSyncId(),
    );
    return db.insert('expenses', savedExpense.toJson());
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
