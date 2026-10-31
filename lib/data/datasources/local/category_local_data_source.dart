import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/category_exception.dart';
import '../../models/category_model.dart';
import 'expense_local_data_source.dart';

class CategoryLocalDataSource {
  const CategoryLocalDataSource(this.databaseSource);

  // Borrow the existing database; the expense source owns opening and closing.
  final ExpenseLocalDataSource databaseSource;

  Future<List<CategoryModel>> getCategories({
    bool includeArchived = false,
  }) async {
    final db = await databaseSource.database;
    final rows = await db.query(
      'categories',
      where: includeArchived ? null : 'isArchived = 0',
      orderBy: 'isIncome, normalizedName, id',
    );
    return rows.map(CategoryModel.fromJson).toList();
  }

  Future<String> saveCategory(
    CategoryModel model, {
    required bool isNew,
  }) async {
    final db = await databaseSource.database;
    return db.transaction((transaction) async {
      var saved = model;
      if (!isNew) {
        final previous = await _find(transaction, model.id);
        if (previous.isArchived == 1) {
          throw const CategoryException(CategoryProblem.archived);
        }
        if (previous.isIncome != model.isIncome) {
          throw const CategoryException(CategoryProblem.typeChange);
        }
        // Preserve translation until the user actually renames a built-in.
        saved = model.copyWith(
          builtInKey: previous.name == model.name ? previous.builtInKey : null,
        );
      }
      await _checkName(transaction, saved);
      if (isNew) {
        await transaction.insert('categories', saved.toJson());
      } else {
        final values = saved.toJson()..remove('id');
        await transaction.update(
          'categories',
          values,
          where: 'id = ?',
          whereArgs: [saved.id],
        );
      }
      return saved.id;
    });
  }

  Future<void> setArchived(String id, bool archived) async {
    final db = await databaseSource.database;
    await db.transaction((transaction) async {
      final current = await _find(transaction, id);
      if (!archived) await _checkName(transaction, current);
      await transaction.update(
        'categories',
        {'isArchived': archived ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<CategoryModel> _find(Transaction transaction, String id) async {
    final rows = await transaction.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) throw const CategoryException(CategoryProblem.notFound);
    return CategoryModel.fromJson(rows.single);
  }

  Future<void> _checkName(Transaction transaction, CategoryModel model) async {
    final duplicates = await transaction.query(
      'categories',
      columns: ['id'],
      where:
          'normalizedName = ? AND isIncome = ? AND isArchived = 0 AND id != ?',
      whereArgs: [model.normalizedName, model.isIncome, model.id],
      limit: 1,
    );
    if (duplicates.isNotEmpty) {
      throw const CategoryException(CategoryProblem.duplicateName);
    }
  }
}
