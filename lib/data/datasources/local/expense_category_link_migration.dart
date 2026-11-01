import 'package:sqflite/sqflite.dart';

// Historical v1-v5 enum order. Do not reorder these persisted indices.
const legacyCategoryIds = [
  'default-food',
  'default-transport',
  'default-entertainment',
  'default-shopping',
  'default-health',
  'default-others',
  'default-income',
];

Future<void> linkExpenseCategories(Database db) async {
  await db.execute(
    'ALTER TABLE expenses ADD COLUMN categoryId TEXT REFERENCES categories(id)',
  );
  final rows = await db.query('expenses', columns: ['id', 'category']);
  for (final row in rows) {
    final index = row['category'];
    if (index is! int || index < 0 || index >= legacyCategoryIds.length) {
      throw const FormatException('Unknown legacy transaction category');
    }
    await db.update(
      'expenses',
      {'categoryId': legacyCategoryIds[index]},
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }
  // ALTER TABLE keeps all original fields and the autoincrement sequence.
  // Foreign keys prevent orphans; these triggers also reject null references.
  await db.execute('''
    CREATE TRIGGER expenses_require_category_insert BEFORE INSERT ON expenses
    WHEN NEW.categoryId IS NULL
    BEGIN SELECT RAISE(ABORT, 'categoryId is required'); END
  ''');
  await db.execute('''
    CREATE TRIGGER expenses_require_category_update BEFORE UPDATE OF categoryId ON expenses
    WHEN NEW.categoryId IS NULL
    BEGIN SELECT RAISE(ABORT, 'categoryId is required'); END
  ''');
}
