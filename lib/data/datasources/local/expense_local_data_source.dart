import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../models/expense_model.dart';
import '../../models/category_model.dart';
import '../../../domain/entities/category_exception.dart';
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
          onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
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
    return db.transaction((transaction) async {
      final categoryRows = await transaction.query('categories');
      final categories = {
        for (final row in categoryRows)
          row['id'] as String: CategoryModel.fromJson(row),
      };
      final rows = await transaction.query(
        'expenses',
        orderBy: 'date DESC, id DESC',
      );
      return rows.map((row) {
        final model = ExpenseModel.fromJson(row);
        final category = categories[model.categoryId];
        if (category == null) {
          throw const FormatException('Missing transaction category');
        }
        return model.copyWith(categoryDetails: category);
      }).toList();
    });
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    return db.transaction((transaction) async {
      final categories = await transaction.query(
        'categories',
        where: 'id = ?',
        whereArgs: [expense.categoryId],
      );
      if (categories.isEmpty) {
        throw const CategoryException(CategoryProblem.notFound);
      }
      final category = CategoryModel.fromJson(categories.single);
      if (category.isArchived == 1) {
        throw const CategoryException(CategoryProblem.archived);
      }
      if (category.isIncome != expense.isIncome) {
        throw const CategoryException(CategoryProblem.typeChange);
      }
      final savedExpense = expense.copyWith(
        syncId: expense.syncId ?? createSyncId(),
      );
      return transaction.insert('expenses', savedExpense.toJson());
    });
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
