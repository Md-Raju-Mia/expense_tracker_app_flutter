import 'expense.dart';
import 'expense_category.dart';

class ExpenseSummary {
  ExpenseSummary(List<Expense> expenses, {this.currencyCode = 'USD'})
    : expenses = List.unmodifiable(expenses);

  final List<Expense> expenses;
  final String currencyCode;

  // BigInt keeps totals exact even when many transactions exceed int64.
  BigInt get totalIncomeMinor => _total(isIncome: true);
  BigInt get totalExpenseMinor => _total(isIncome: false);
  BigInt get balanceMinor => totalIncomeMinor - totalExpenseMinor;

  BigInt _total({required bool isIncome}) {
    var total = BigInt.zero;
    for (final expense in expenses) {
      if (expense.isIncome == isIncome &&
          expense.currencyCode == currencyCode) {
        total += BigInt.from(expense.amountMinor);
      }
    }
    return total;
  }

  Map<ExpenseCategory, BigInt> get categoryTotalsMinor {
    final totals = <ExpenseCategory, BigInt>{};
    for (final expense in expenses) {
      if (!expense.isIncome && expense.currencyCode == currencyCode) {
        final previousTotal = totals[expense.category] ?? BigInt.zero;
        totals[expense.category] =
            previousTotal + BigInt.from(expense.amountMinor);
      }
    }
    return totals;
  }
}
