import 'package:flutter/material.dart';

import '../../../core/theme/expense_theme.dart';
import '../../../domain/entities/expense_summary.dart';
import '../../../l10n/l10n.dart';
import 'expense_amount.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({super.key, required this.summary});
  final ExpenseSummary summary;

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: ExpenseTheme.balanceColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            text.expenseTotalBalance,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            expenseAmount(
              summary.balance,
              summary.currencyCode,
              text.localeName,
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text.expenseTotalsCurrency(summary.currencyCode),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 280 ||
                  MediaQuery.textScalerOf(context).scale(16) > 24;
              final width = stacked
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 16) / 2;
              return Wrap(
                spacing: 16,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: width,
                    child: _item(
                      context,
                      text.expenseIncome,
                      summary.totalIncome,
                      Icons.arrow_downward,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _item(
                      context,
                      text.expenseExpenses,
                      summary.totalExpense,
                      Icons.arrow_upward,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                expenseAmount(
                  amount,
                  summary.currencyCode,
                  context.l10n.localeName,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
