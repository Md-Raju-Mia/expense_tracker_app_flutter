import '../entities/expense.dart';

abstract interface class ExpenseRepository {
  // Return all transactions in date-descending order, as in the old app.
  Future<List<Expense>> getExpenses();

  Future<int> insertExpense(Expense expense);

  Future<int> deleteExpense(int id);
}
