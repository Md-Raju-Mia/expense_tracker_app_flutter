import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/expense.dart';
import 'expense_category_style.dart';

class ExpenseTransactionList extends StatelessWidget {
  const ExpenseTransactionList({
    super.key,
    required this.expenses,
    required this.onDelete,
  });
  final List<Expense> expenses;
  final ValueChanged<int> onDelete;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((ctx, i) {
          final expense = expenses[i];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: expense.category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  expense.category.icon,
                  color: expense.category.color,
                ),
              ),
              title: Text(
                expense.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('MMM dd, yyyy').format(expense.date),
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${expense.isIncome ? "+" : "-"}\$${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: expense.isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => onDelete(expense.id!),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: expenses.length),
      ),
    );
  }
}
