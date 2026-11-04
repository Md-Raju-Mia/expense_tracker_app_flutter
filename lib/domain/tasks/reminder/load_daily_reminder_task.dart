import '../../../core/base/base_task.dart';
import '../../entities/daily_reminder.dart';
import '../../repositories/daily_reminder_repository.dart';

class LoadDailyReminderTask extends BaseTask<DailyReminder> {
  const LoadDailyReminderTask(this.repository);
  final DailyReminderRepository repository;

  @override
  String get name => 'Load daily reminder';

  @override
  Future<DailyReminder> run() => repository.load();
}
