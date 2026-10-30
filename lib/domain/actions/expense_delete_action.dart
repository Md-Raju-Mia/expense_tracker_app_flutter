import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/expense/delete_expense_task.dart';

class ExpenseDeleteAction extends BaseAction {
  ExpenseDeleteAction(this.task);

  final DeleteExpenseTask task;

  @override
  Future<void> run() async {
    await TaskChain.start(() => runTask(task)).execute();
  }
}
