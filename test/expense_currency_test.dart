import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';

void main() {
  test('summary does not add or convert amounts from different currencies', () {
    final rows = [
      Expense(
        title: 'USD expense',
        amountMinor: 1200,
        date: DateTime(2026),
        category: ExpenseCategory.food,
      ),
      Expense(
        title: 'BDT expense',
        amountMinor: 10000,
        date: DateTime(2026),
        category: ExpenseCategory.shopping,
        currencyCode: 'BDT',
      ),
      Expense(
        title: 'BDT income',
        amountMinor: 20000,
        date: DateTime(2026),
        category: ExpenseCategory.income,
        currencyCode: 'BDT',
        isIncome: true,
      ),
      Expense(
        title: 'INR expense',
        amountMinor: 4000,
        date: DateTime(2026),
        category: ExpenseCategory.health,
        currencyCode: 'INR',
      ),
    ];
    final taka = ExpenseSummary(rows, currencyCode: 'BDT');
    expect(taka.totalIncomeMinor, BigInt.from(20000));
    expect(taka.totalExpenseMinor, BigInt.from(10000));
    expect(taka.balanceMinor, BigInt.from(10000));
    expect(taka.categoryTotalsMinor, {
      ExpenseCategory.shopping: BigInt.from(10000),
    });
    expect(taka.expenses, hasLength(4));
    final dollars = ExpenseSummary(rows);
    expect(dollars.totalExpenseMinor, BigInt.from(1200));
    expect(dollars.balanceMinor, BigInt.from(-1200));
    expect(rows[0].amountMinor, 1200);
    expect(rows[0].currencyCode, 'USD');
  });
}
