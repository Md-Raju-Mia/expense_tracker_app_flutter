import '../../../core/base/base_task.dart';
import '../../entities/daily_reminder.dart';
import '../../repositories/daily_reminder_repository.dart';

class SaveDailyReminderTask extends BaseTask<DailyReminder> {
  const SaveDailyReminderTask(this.repository, this.enabled, this.minutes);
  final DailyReminderRepository repository;
  final bool enabled;
  final int minutes;

  @override
  String get name => 'Save daily reminder';

  @override
  Future<DailyReminder> run() =>
      repository.save(enabled: enabled, minutes: minutes);
}
