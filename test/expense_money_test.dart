import 'support/test_categories.dart';

import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_amount.dart';
import 'package:fleet_wise_user_app/ui/expense/widgets/expense_amount.dart';
import 'package:flutter_test/flutter_test.dart';

Expense row(String input, {bool income = false, String currency = 'BDT'}) =>
    Expense(
      title: input,
      amountMinor: TransactionAmount.parse(input).minorUnits,
      date: DateTime(2026),
      category: income ? TestCategories.income : TestCategories.food,
      isIncome: income,
      currencyCode: currency,
    );

void main() {
  test('decimal income, expense, balance and categories reconcile exactly', () {
    final summary = ExpenseSummary([
      row('0.30', income: true),
      row('0.10'),
      row('0.20'),
      row('999', currency: 'USD'),
    ], currencyCode: 'BDT');
    expect(summary.totalIncomeMinor, BigInt.from(30));
    expect(summary.totalExpenseMinor, BigInt.from(30));
    expect(summary.balanceMinor, BigInt.zero);
    expect(summary.categoryTotalsMinor[TestCategories.food], BigInt.from(30));
    expect(expenseAmount(summary.balanceMinor, 'BDT', 'en'), '৳0.00');
  });

  test(
    'large totals exceed int64 without overflow or display precision loss',
    () {
      final maximum = row('9999999999999.99');
      final summary = ExpenseSummary(
        List.filled(10000, maximum),
        currencyCode: 'BDT',
      );
      final expected = BigInt.parse('9999999999999990000');
      expect(summary.totalExpenseMinor, expected);
      expect(summary.balanceMinor, -expected);
      expect(summary.categoryTotalsMinor[TestCategories.food], expected);
      expect(expenseAmount(expected, 'BDT', 'en'), '৳99999999999999900.00');
      expect(
        expenseAmount(expected + BigInt.one, 'USD', 'en'),
        '\$99999999999999900.01',
      );
    },
  );

  test('amount display preserves cents, signs and Bengali digits', () {
    expect(expenseAmount(BigInt.from(29), 'USD', 'en'), '\$0.29');
    expect(expenseAmount(BigInt.from(125050), 'BDT', 'bn'), '৳১২৫০.৫০');
    expect(expenseAmount(BigInt.from(-1), 'INR', 'bn'), '₹-০.০১');
    expect(
      expenseAmount(BigInt.parse('-9223372036854775808'), 'USD', 'en'),
      '\$-92233720368547758.08',
    );
  });
}
