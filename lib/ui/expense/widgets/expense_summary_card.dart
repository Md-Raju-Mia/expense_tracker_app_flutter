import 'package:flutter/material.dart';

import '../../../domain/entities/expense_summary.dart';
import '../../../l10n/l10n.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({super.key, required this.summary});
  final ExpenseSummary summary;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.tealAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            context.l10n.expenseTotalBalance,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${summary.balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem(
                context.l10n.expenseIncome,
                summary.totalIncome,
                Icons.arrow_downward,
                Colors.white,
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              _summaryItem(
                context.l10n.expenseExpenses,
                summary.totalExpense,
                Icons.arrow_upward,
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, double amount, IconData icon, Color color) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 15,
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
