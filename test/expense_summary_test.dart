import 'support/test_categories.dart';

import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';
import 'package:flutter_test/flutter_test.dart';

Expense transaction(
  double amount,
  TransactionCategory category, {
  bool isIncome = false,
}) {
  return Expense(
    title: 'Transaction',
    amountMinor: (amount * 100).round(),
    date: DateTime(2026, 4, 9),
    category: category,
    isIncome: isIncome,
  );
}

void main() {
  test('empty transactions have zero totals and no category totals', () {
    final summary = ExpenseSummary([]);

    expect(summary.totalIncomeMinor, BigInt.from(0));
    expect(summary.totalExpenseMinor, BigInt.from(0));
    expect(summary.balanceMinor, BigInt.from(0));
    expect(summary.categoryTotalsMinor, isEmpty);
  });

  test('reference screenshot transactions produce the original totals', () {
    final summary = ExpenseSummary([
      transaction(1000, TestCategories.others),
      transaction(2000, TestCategories.health),
      transaction(3000, TestCategories.transport),
      transaction(6000, TestCategories.shopping),
      transaction(5000, TestCategories.food),
      transaction(30000, TestCategories.income, isIncome: true),
    ]);

    expect(summary.totalIncomeMinor, BigInt.from(3000000));
    expect(summary.totalExpenseMinor, BigInt.from(1700000));
    expect(summary.balanceMinor, BigInt.from(1300000));
    expect(summary.categoryTotalsMinor, {
      TestCategories.others: BigInt.from(100000),
      TestCategories.health: BigInt.from(200000),
      TestCategories.transport: BigInt.from(300000),
      TestCategories.shopping: BigInt.from(600000),
      TestCategories.food: BigInt.from(500000),
    });
    expect(summary.categoryTotalsMinor.keys.toList(), [
      TestCategories.others,
      TestCategories.health,
      TestCategories.transport,
      TestCategories.shopping,
      TestCategories.food,
    ]);
  });

  test('repeated categories merge without changing first encounter order', () {
    final summary = ExpenseSummary([
      transaction(10.5, TestCategories.food),
      transaction(7, TestCategories.transport),
      transaction(2.25, TestCategories.food),
    ]);

    expect(summary.totalExpenseMinor, BigInt.from(1975));
    expect(summary.balanceMinor, BigInt.from(-1975));
    expect(summary.categoryTotalsMinor[TestCategories.food], BigInt.from(1275));
    expect(summary.categoryTotalsMinor.keys.toList(), [
      TestCategories.food,
      TestCategories.transport,
    ]);
  });

  test('income-only transactions do not create chart categories', () {
    final summary = ExpenseSummary([
      transaction(50, TestCategories.income, isIncome: true),
    ]);

    expect(summary.totalIncomeMinor, BigInt.from(5000));
    expect(summary.totalExpenseMinor, BigInt.from(0));
    expect(summary.balanceMinor, BigInt.from(5000));
    expect(summary.categoryTotalsMinor, isEmpty);
  });

  test('zero and negative amounts remain part of the calculations', () {
    final summary = ExpenseSummary([
      transaction(0, TestCategories.food),
      transaction(-10, TestCategories.transport),
      transaction(-5, TestCategories.income, isIncome: true),
    ]);

    expect(summary.totalIncomeMinor, BigInt.from(-500));
    expect(summary.totalExpenseMinor, BigInt.from(-1000));
    expect(summary.balanceMinor, BigInt.from(500));
    expect(summary.categoryTotalsMinor, {
      TestCategories.food: BigInt.from(0),
      TestCategories.transport: BigInt.from(-1000),
    });
  });

  test('isIncome determines totals independently of category', () {
    final summary = ExpenseSummary([
      transaction(20, TestCategories.food, isIncome: true),
      transaction(7, TestCategories.income),
    ]);

    expect(summary.totalIncomeMinor, BigInt.from(2000));
    expect(summary.totalExpenseMinor, BigInt.from(700));
    expect(summary.categoryTotalsMinor, {
      TestCategories.income: BigInt.from(700),
    });
  });

  test('summary keeps its snapshot when the input list changes', () {
    final expenses = [transaction(12, TestCategories.food)];
    final summary = ExpenseSummary(expenses);
    expenses.clear();

    expect(summary.totalExpenseMinor, BigInt.from(1200));
    expect(() => summary.expenses.clear(), throwsUnsupportedError);
  });
}
