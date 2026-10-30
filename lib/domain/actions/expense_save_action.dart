import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/expense/save_expense_task.dart';

class ExpenseSaveAction extends BaseAction {
  ExpenseSaveAction(this.task);

  final SaveExpenseTask task;

  @override
  Future<void> run() async {
    await TaskChain.start(() => runTask(task)).execute();
  }
}
