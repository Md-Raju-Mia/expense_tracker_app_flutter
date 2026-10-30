import 'expense.dart';
import 'expense_category.dart';

class ExpenseSummary {
  ExpenseSummary(List<Expense> expenses)
    : expenses = List.unmodifiable(expenses);

  final List<Expense> expenses;

  double get totalIncome {
    double total = 0;
    for (final expense in expenses) {
      if (expense.isIncome) {
        total += expense.amount;
      }
    }
    return total;
  }

  double get totalExpense {
    double total = 0;
    for (final expense in expenses) {
      if (!expense.isIncome) {
        total += expense.amount;
      }
    }
    return total;
  }

  double get balance => totalIncome - totalExpense;

  Map<ExpenseCategory, double> get categoryTotals {
    final totals = <ExpenseCategory, double>{};
    for (final expense in expenses) {
      if (!expense.isIncome) {
        final previousTotal = totals[expense.category] ?? 0;
        totals[expense.category] = previousTotal + expense.amount;
      }
    }
    return totals;
  }
}
