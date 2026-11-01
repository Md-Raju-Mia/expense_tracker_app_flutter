import '../../../core/base/base_task.dart';
import '../../entities/expense.dart';
import '../../entities/transaction_amount.dart';
import '../../entities/category_exception.dart';
import '../../repositories/expense_repository.dart';

class SaveExpenseTask extends BaseTask<int> {
  const SaveExpenseTask(this.repository, this.expense);

  final ExpenseRepository repository;
  final Expense expense;

  @override
  String get name => 'Save expense';

  @override
  Future<int> run() async {
    if (expense.title.trim().isEmpty) {
      throw const FormatException('Transaction title is required');
    }
    TransactionAmount.fromMinorUnits(expense.amountMinor);
    if (expense.category.isArchived) {
      throw const CategoryException(CategoryProblem.archived);
    }
    if (expense.category.isIncome != expense.isIncome) {
      throw const CategoryException(CategoryProblem.typeChange);
    }
    return repository.insertExpense(expense);
  }
}
