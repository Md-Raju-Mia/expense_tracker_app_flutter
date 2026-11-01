import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/expense_theme.dart';
import '../../../domain/entities/expense.dart';
import '../../../l10n/l10n.dart';
import 'expense_amount.dart';
import '../../categories/widgets/category_style.dart';

class ExpenseTransactionList extends StatelessWidget {
  const ExpenseTransactionList({
    super.key,
    required this.expenses,
    required this.onDelete,
    this.onEdit,
  });
  final List<Expense> expenses;
  final ValueChanged<int> onDelete;
  final ValueChanged<int>? onEdit;

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final theme = Theme.of(context);
    final labels = categoryLabels(
      context,
      expenses.map((expense) => expense.category),
    );
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverList.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: expense.category.color
                          .foreground(context)
                          .withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      expense.category.icon.materialIcon,
                      color: expense.category.color.foreground(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[expense.category.id]!,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          DateFormat(
                            'MMM dd, yyyy',
                            text.localeName,
                          ).format(expense.date),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${expense.isIncome ? '+' : '-'}${expenseAmount(BigInt.from(expense.amountMinor), expense.currencyCode, text.localeName)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: expense.isIncome
                                ? ExpenseTheme.incomeColor
                                : ExpenseTheme.expenseColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          expense.currencyCode,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          key: ValueKey('edit-expense-${expense.id}'),
                          tooltip: text.expenseEditTransaction,
                          onPressed: () => onEdit!(expense.id!),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      IconButton(
                        tooltip: text.expenseDelete,
                        onPressed: () => onDelete(expense.id!),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
