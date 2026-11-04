import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../entities/daily_reminder.dart';
import '../tasks/reminder/save_daily_reminder_task.dart';

class ReminderSaveAction extends BaseAction {
  ReminderSaveAction(this.task);
  final SaveDailyReminderTask task;
  DailyReminder? result;

  @override
  Future<void> run() async {
    result = await TaskChain.start(() => runTask(task)).execute();
  }
}
