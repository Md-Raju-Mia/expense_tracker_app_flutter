import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';
import 'package:flutter_test/flutter_test.dart';

Expense transaction(
  double amount,
  ExpenseCategory category, {
  bool isIncome = false,
}) {
  return Expense(
    title: 'Transaction',
    amount: amount,
    date: DateTime(2026, 4, 9),
    category: category,
    isIncome: isIncome,
  );
}

void main() {
  test('empty transactions have zero totals and no category totals', () {
    final summary = ExpenseSummary([]);

    expect(summary.totalIncome, 0);
    expect(summary.totalExpense, 0);
    expect(summary.balance, 0);
    expect(summary.categoryTotals, isEmpty);
  });

  test('reference screenshot transactions produce the original totals', () {
    final summary = ExpenseSummary([
      transaction(1000, ExpenseCategory.others),
      transaction(2000, ExpenseCategory.health),
      transaction(3000, ExpenseCategory.transport),
      transaction(6000, ExpenseCategory.shopping),
      transaction(5000, ExpenseCategory.food),
      transaction(30000, ExpenseCategory.income, isIncome: true),
    ]);

    expect(summary.totalIncome, 30000);
    expect(summary.totalExpense, 17000);
    expect(summary.balance, 13000);
    expect(summary.categoryTotals, {
      ExpenseCategory.others: 1000,
      ExpenseCategory.health: 2000,
      ExpenseCategory.transport: 3000,
      ExpenseCategory.shopping: 6000,
      ExpenseCategory.food: 5000,
    });
    expect(summary.categoryTotals.keys.toList(), [
      ExpenseCategory.others,
      ExpenseCategory.health,
      ExpenseCategory.transport,
      ExpenseCategory.shopping,
      ExpenseCategory.food,
    ]);
  });

  test('repeated categories merge without changing first encounter order', () {
    final summary = ExpenseSummary([
      transaction(10.5, ExpenseCategory.food),
      transaction(7, ExpenseCategory.transport),
      transaction(2.25, ExpenseCategory.food),
    ]);

    expect(summary.totalExpense, 19.75);
    expect(summary.balance, -19.75);
    expect(summary.categoryTotals[ExpenseCategory.food], 12.75);
    expect(summary.categoryTotals.keys.toList(), [
      ExpenseCategory.food,
      ExpenseCategory.transport,
    ]);
  });

  test('income-only transactions do not create chart categories', () {
    final summary = ExpenseSummary([
      transaction(50, ExpenseCategory.income, isIncome: true),
    ]);

    expect(summary.totalIncome, 50);
    expect(summary.totalExpense, 0);
    expect(summary.balance, 50);
    expect(summary.categoryTotals, isEmpty);
  });

  test('zero and negative amounts remain part of the calculations', () {
    final summary = ExpenseSummary([
      transaction(0, ExpenseCategory.food),
      transaction(-10, ExpenseCategory.transport),
      transaction(-5, ExpenseCategory.income, isIncome: true),
    ]);

    expect(summary.totalIncome, -5);
    expect(summary.totalExpense, -10);
    expect(summary.balance, 5);
    expect(summary.categoryTotals, {
      ExpenseCategory.food: 0,
      ExpenseCategory.transport: -10,
    });
  });

  test('isIncome determines totals independently of category', () {
    final summary = ExpenseSummary([
      transaction(20, ExpenseCategory.food, isIncome: true),
      transaction(7, ExpenseCategory.income),
    ]);

    expect(summary.totalIncome, 20);
    expect(summary.totalExpense, 7);
    expect(summary.categoryTotals, {ExpenseCategory.income: 7});
  });

  test('summary keeps its snapshot when the input list changes', () {
    final expenses = [transaction(12, ExpenseCategory.food)];
    final summary = ExpenseSummary(expenses);
    expenses.clear();

    expect(summary.totalExpense, 12);
    expect(() => summary.expenses.clear(), throwsUnsupportedError);
  });

  test('category indices match the existing database values', () {
    expect(ExpenseCategory.values.map((category) => category.name).toList(), [
      'food',
      'transport',
      'entertainment',
      'shopping',
      'health',
      'others',
      'income',
    ]);
  });
}
