import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/expense/export_expense_history_task.dart';

class ExpenseHistoryExportAction extends BaseAction {
  ExpenseHistoryExportAction(this.task);

  final ExportExpenseHistoryTask task;
  bool completed = false;

  @override
  Future<void> run() async {
    completed = await TaskChain.start(() => runTask(task)).execute();
  }
}
