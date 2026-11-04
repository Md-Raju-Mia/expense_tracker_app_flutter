import '../../../core/base/base_view_model.dart';
import '../../../domain/actions/reminder_save_action.dart';
import '../../../domain/entities/daily_reminder.dart';
import '../../../domain/tasks/reminder/load_daily_reminder_task.dart';

class DailyReminderViewModel extends BaseViewModel {
  DailyReminderViewModel(this.loadTask, this.createSaveAction);

  final LoadDailyReminderTask loadTask;
  final ReminderSaveAction Function(bool, int) createSaveAction;

  DailyReminder? reminder;
  bool fetching = false;
  bool loadFailed = false;
  bool get busy => fetching || isLoading;

  Future<void> load() async {
    if (busy || isDisposed) return;
    fetching = true;
    loadFailed = false;
    notifyListeners();
    try {
      final loaded = await loadTask.run();
      if (!isDisposed) reminder = loaded;
    } catch (_) {
      if (!isDisposed) loadFailed = true;
    } finally {
      fetching = false;
      if (!isDisposed) notifyListeners();
    }
  }

  Future<void> save({required bool enabled, required int minutes}) async {
    if (busy || isDisposed) return;
    final action = createSaveAction(enabled, minutes);
    await execute(action);
    if (isDisposed || action.result == null) return;
    reminder = action.result;
    notifyListeners();
  }
}
