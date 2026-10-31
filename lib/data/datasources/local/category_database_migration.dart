import 'package:sqflite/sqflite.dart';

Future<void> createCategoryTable(Database db) async {
  await db.execute('''
    CREATE TABLE categories (
      id TEXT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL,
      normalizedName TEXT NOT NULL,
      iconKey TEXT NOT NULL,
      colorKey TEXT NOT NULL,
      isIncome INTEGER NOT NULL CHECK (isIncome IN (0, 1)),
      builtInKey TEXT,
      isArchived INTEGER NOT NULL DEFAULT 0 CHECK (isArchived IN (0, 1))
    )
  ''');
  await db.execute('''
    CREATE UNIQUE INDEX categories_active_name
    ON categories(isIncome, normalizedName) WHERE isArchived = 0
  ''');
  const defaults = [
    ('food', 'Food', 'orange'),
    ('transport', 'Transport', 'blue'),
    ('entertainment', 'Entertainment', 'purple'),
    ('shopping', 'Shopping', 'pink'),
    ('health', 'Health', 'red'),
    ('others', 'Others', 'grey'),
    ('income', 'Income', 'green'),
  ];
  for (final (key, name, color) in defaults) {
    await db.insert('categories', {
      'id': 'default-$key',
      'name': name,
      'normalizedName': name.toLowerCase(),
      'iconKey': key,
      'colorKey': color,
      'isIncome': key == 'income' ? 1 : 0,
      'builtInKey': key,
      'isArchived': 0,
    });
  }
}
