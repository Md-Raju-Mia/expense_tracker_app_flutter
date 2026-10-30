import 'expense_category.dart';

class Expense {
  const Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.isIncome = false,
  });

  // New transactions do not have an ID until the database saves them.
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final bool isIncome;
}
