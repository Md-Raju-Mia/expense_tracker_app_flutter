import 'package:flutter/material.dart';

import '../../../domain/entities/expense_category.dart';
import 'expense_category_style.dart';

class ExpenseCategoryPicker extends StatelessWidget {
  const ExpenseCategoryPicker({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });
  final ExpenseCategory selectedCategory;
  final ValueChanged<ExpenseCategory> onSelected;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ExpenseCategory.values
          .where((cat) => cat != ExpenseCategory.income)
          .map(
            (cat) => ChoiceChip(
              label: Text(cat.label(context).toUpperCase()),
              avatar: Icon(cat.icon, size: 18, color: cat.color),
              selected: selectedCategory == cat,
              onSelected: (selected) {
                if (selected) onSelected(cat);
              },
              selectedColor: cat.color.withValues(alpha: 0.16),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          )
          .toList(),
    );
  }
}
