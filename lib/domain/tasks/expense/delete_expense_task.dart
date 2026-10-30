import '../../../core/base/base_task.dart';
import '../../repositories/expense_repository.dart';

class DeleteExpenseTask extends BaseTask<int> {
  const DeleteExpenseTask(this.repository, this.id);

  final ExpenseRepository repository;
  final int id;

  @override
  String get name => 'Delete expense';

  @override
  Future<int> run() => repository.deleteExpense(id);
}
