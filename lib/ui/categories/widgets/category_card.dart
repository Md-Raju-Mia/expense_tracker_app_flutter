import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../domain/entities/transaction_category.dart';
import '../../../l10n/l10n.dart';
import 'category_style.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onArchive,
    required this.enabled,
    required this.displayName,
  });
  final TransactionCategory category;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final bool enabled;
  final String displayName;
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  category.icon.materialIcon,
                  color: category.color.foreground(context),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(displayName, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.isIncome ? text.expenseIncome : text.expenseTypeExpense,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (!category.isArchived)
                  OutlinedButton.icon(
                    onPressed: enabled ? onEdit : null,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(text.categoriesEdit),
                  ),
                TextButton.icon(
                  onPressed: enabled ? onArchive : null,
                  icon: Icon(
                    category.isArchived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                  ),
                  label: Text(
                    category.isArchived
                        ? text.categoriesRestore
                        : text.categoriesArchive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
