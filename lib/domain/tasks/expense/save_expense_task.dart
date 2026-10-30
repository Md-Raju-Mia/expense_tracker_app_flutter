import '../../../core/base/base_task.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

class SaveExpenseTask extends BaseTask<int> {
  const SaveExpenseTask(this.repository, this.expense);

  final ExpenseRepository repository;
  final Expense expense;

  @override
  String get name => 'Save expense';

  @override
  Future<int> run() => repository.insertExpense(expense);
}
