import '../entities/daily_reminder.dart';

abstract interface class DailyReminderRepository {
  Future<DailyReminder> load();
  Future<DailyReminder> save({required bool enabled, required int minutes});
}
