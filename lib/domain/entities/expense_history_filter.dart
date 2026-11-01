import 'expense.dart';

enum ExpenseHistoryPeriod { all, day, month, year }

class ExpenseHistoryFilter {
  const ExpenseHistoryFilter({required this.period, required this.date});

  final ExpenseHistoryPeriod period;
  final DateTime date;

  bool matches(Expense expense) {
    final value = expense.date;
    return switch (period) {
      ExpenseHistoryPeriod.all => true,
      ExpenseHistoryPeriod.year => value.year == date.year,
      ExpenseHistoryPeriod.month =>
        value.year == date.year && value.month == date.month,
      ExpenseHistoryPeriod.day =>
        value.year == date.year &&
            value.month == date.month &&
            value.day == date.day,
    };
  }
}
