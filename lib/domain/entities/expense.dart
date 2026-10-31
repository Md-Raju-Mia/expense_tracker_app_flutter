import 'expense_category.dart';

class Expense {
  const Expense({
    this.id,
    this.syncId,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.isIncome = false,
  });

  // New transactions do not have an ID until the database saves them.
  final int? id;
  // A stable identity across devices. Assigned when a new expense is saved.
  final String? syncId;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final bool isIncome;
}
