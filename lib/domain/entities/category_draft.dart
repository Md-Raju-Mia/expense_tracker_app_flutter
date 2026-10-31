import 'package:characters/characters.dart';

import 'transaction_category.dart';
import 'category_exception.dart';

class CategoryDraft {
  static const maxNameLength = 60;
  const CategoryDraft({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isIncome,
  });

  // Null means create a new category; an existing ID means edit.
  final String? id;
  final String name;
  final CategoryIcon icon;
  final CategoryColor color;
  final bool isIncome;

  void validate() {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.characters.length > maxNameLength) {
      throw const CategoryException(CategoryProblem.invalidName);
    }
  }
}
