import 'transaction_category.dart';

class Expense {
  const Expense({
    this.id,
    this.syncId,
    this.currencyCode = 'USD',
    required this.title,
    required this.amountMinor,
    required this.date,
    required this.category,
    this.isIncome = false,
  });

  // New transactions do not have an ID until the database saves them.
  final int? id;
  // A stable identity across devices. Assigned when a new expense is saved.
  final String? syncId;
  final String currencyCode;
  final String title;
  // Two-decimal currencies: 1250 means 12.50 taka/rupees/dollars.
  final int amountMinor;
  final DateTime date;
  final TransactionCategory category;
  final bool isIncome;
}
