import '../../../core/base/base_task.dart';
import '../../entities/expense.dart';
import '../../entities/expense_exception.dart';
import '../../entities/transaction_amount.dart';
import '../../repositories/expense_repository.dart';

class UpdateExpenseTask extends BaseTask<int> {
  const UpdateExpenseTask(this.repository, this.expense);
  final ExpenseRepository repository;
  final Expense expense;

  @override
  String get name => 'Update expense';

  @override
  Future<int> run() async {
    if (expense.id == null || expense.id! <= 0) {
      throw const ExpenseException(ExpenseProblem.notFound);
    }
    if (expense.title.trim().isEmpty) {
      throw const FormatException('Transaction title is required');
    }
    TransactionAmount.fromMinorUnits(expense.amountMinor);
    // Storage checks the current category and immutable fields atomically.
    return repository.updateExpense(expense);
  }
}
