import 'package:flutter/material.dart';

import '../../../domain/entities/expense_summary.dart';
import '../../../l10n/l10n.dart';
import 'expense_summary_card.dart';
import 'expense_spending_chart.dart';
import 'expense_transaction_list.dart';

class ExpenseHomeContent extends StatelessWidget {
  const ExpenseHomeContent({
    super.key,
    required this.summary,
    required this.onDelete,
    this.onEdit,
  });

  final ExpenseSummary summary;
  final ValueChanged<int> onDelete;
  final ValueChanged<int>? onEdit;

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleLarge
        ?.copyWith(fontWeight: FontWeight.bold);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ExpenseSummaryCard(summary: summary)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(context.l10n.expenseSpendingAnalysis, style: heading),
          ),
        ),
        SliverToBoxAdapter(child: ExpenseSpendingChart(summary: summary)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.expenseRecentTransactions,
                    style: heading,
                  ),
                ),
                // The old app intentionally has no See All navigation.
                TextButton(
                  onPressed: () {},
                  child: Text(context.l10n.expenseSeeAll),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(context.l10n.expenseAllCurrencies),
          ),
        ),
        ExpenseTransactionList(
          expenses: summary.expenses,
          onDelete: onDelete,
          onEdit: onEdit,
        ),
      ],
    );
  }
}
