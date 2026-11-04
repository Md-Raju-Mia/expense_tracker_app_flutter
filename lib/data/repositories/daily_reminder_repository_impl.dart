import '../../core/utils/platform/android_daily_reminder.dart';
import '../../domain/entities/daily_reminder.dart';
import '../../domain/repositories/daily_reminder_repository.dart';

class DailyReminderRepositoryImpl implements DailyReminderRepository {
  const DailyReminderRepositoryImpl(this.platform);
  final AndroidDailyReminder platform;

  @override
  Future<DailyReminder> load() async => platform.isSupported
      ? _decode(await platform.load())
      : const DailyReminder(1200, ReminderStatus.unsupported);

  @override
  Future<DailyReminder> save({
    required bool enabled,
    required int minutes,
  }) async => _decode(await platform.save(enabled, minutes));

  DailyReminder _decode(Map<String, Object?> data) {
    final status = !(data['enabled'] as bool)
        ? ReminderStatus.off
        : (data['allowed'] as bool)
        ? ReminderStatus.scheduled
        : ReminderStatus.blocked;
    return DailyReminder(data['minutes'] as int, status);
  }
}
