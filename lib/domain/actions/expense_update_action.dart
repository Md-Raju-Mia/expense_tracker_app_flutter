import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/expense/update_expense_task.dart';

class ExpenseUpdateAction extends BaseAction {
  ExpenseUpdateAction(this.task);
  final UpdateExpenseTask task;

  @override
  Future<void> run() async {
    await TaskChain.start(() => runTask(task)).execute();
  }
}
