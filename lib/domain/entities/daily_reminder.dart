enum ReminderStatus { off, scheduled, blocked, unsupported }

class DailyReminder {
  const DailyReminder(this.minutes, this.status);

  final int minutes;
  final ReminderStatus status;

  bool get enabled =>
      status == ReminderStatus.scheduled || status == ReminderStatus.blocked;
}
