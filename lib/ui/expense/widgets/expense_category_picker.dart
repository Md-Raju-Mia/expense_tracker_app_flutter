import 'package:flutter/material.dart';

import '../../../domain/entities/transaction_category.dart';
import '../../categories/widgets/category_style.dart';
import '../../categories/widgets/category_choice_label.dart';

class ExpenseCategoryPicker extends StatelessWidget {
  const ExpenseCategoryPicker({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onSelected,
  });
  final TransactionCategory? selectedCategory;
  final List<TransactionCategory> categories;
  final ValueChanged<TransactionCategory> onSelected;
  @override
  Widget build(BuildContext context) {
    final labels = categoryLabels(context, categories);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories
          .map(
            (cat) => ChoiceChip(
              key: ValueKey('expense-category-${cat.id}'),
              label: CategoryChoiceLabel(labels[cat.id]!),
              avatar: Icon(
                cat.icon.materialIcon,
                size: 18,
                color: cat.color.foreground(context),
              ),
              selected: selectedCategory == cat,
              onSelected: (selected) {
                if (selected) onSelected(cat);
              },
              selectedColor: cat.color
                  .foreground(context)
                  .withValues(alpha: 0.16),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          )
          .toList(),
    );
  }
}
