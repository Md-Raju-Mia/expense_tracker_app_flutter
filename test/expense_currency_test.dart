import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';

void main() {
  test('summary does not add or convert amounts from different currencies', () {
    final rows = [
      Expense(
        title: 'USD expense',
        amount: 12,
        date: DateTime(2026),
        category: ExpenseCategory.food,
      ),
      Expense(
        title: 'BDT expense',
        amount: 100,
        date: DateTime(2026),
        category: ExpenseCategory.shopping,
        currencyCode: 'BDT',
      ),
      Expense(
        title: 'BDT income',
        amount: 200,
        date: DateTime(2026),
        category: ExpenseCategory.income,
        currencyCode: 'BDT',
        isIncome: true,
      ),
      Expense(
        title: 'INR expense',
        amount: 40,
        date: DateTime(2026),
        category: ExpenseCategory.health,
        currencyCode: 'INR',
      ),
    ];
    final taka = ExpenseSummary(rows, currencyCode: 'BDT');
    expect(taka.totalIncome, 200);
    expect(taka.totalExpense, 100);
    expect(taka.balance, 100);
    expect(taka.categoryTotals, {ExpenseCategory.shopping: 100});
    expect(taka.expenses, hasLength(4));
    final dollars = ExpenseSummary(rows);
    expect(dollars.totalExpense, 12);
    expect(dollars.balance, -12);
    expect(rows[0].amount, 12);
    expect(rows[0].currencyCode, 'USD');
  });
}
