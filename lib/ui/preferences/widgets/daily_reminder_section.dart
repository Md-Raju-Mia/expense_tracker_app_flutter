import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../domain/entities/daily_reminder.dart';
import '../../../l10n/l10n.dart';
import '../view_models/daily_reminder_view_model.dart';

class DailyReminderSection extends StatefulWidget {
  const DailyReminderSection({super.key});

  @override
  State<DailyReminderSection> createState() => _DailyReminderSectionState();
}

class _DailyReminderSectionState extends State<DailyReminderSection> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () => context.read<DailyReminderViewModel>().load(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DailyReminderViewModel>();
    final reminder = model.reminder;
    final l10n = context.l10n;
    if (reminder?.status == ReminderStatus.unsupported) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        if (reminder == null)
          Text(
            l10n.reminderTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (model.loadFailed || model.state.error != null)
          Text(
            l10n.reminderError,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (model.loadFailed)
          OutlinedButton(onPressed: model.load, child: Text(l10n.retry))
        else if (reminder != null) ...[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reminderTitle),
            value: reminder.enabled,
            onChanged: model.busy
                ? null
                : (enabled) =>
                      model.save(enabled: enabled, minutes: reminder.minutes),
          ),
          if (reminder.status == ReminderStatus.blocked)
            Text(l10n.reminderBlocked),
          if (reminder.status == ReminderStatus.scheduled)
            Text(l10n.reminderTiming),
          OutlinedButton(
            onPressed: model.busy ? null : () => _pickTime(model, reminder),
            child: Text(l10n.reminderTime(_time(reminder).format(context))),
          ),
        ],
        if (model.busy) LinearProgressIndicator(semanticsLabel: l10n.loading),
      ],
    );
  }

  TimeOfDay _time(DailyReminder reminder) =>
      TimeOfDay(hour: reminder.minutes ~/ 60, minute: reminder.minutes % 60);

  Future<void> _pickTime(
    DailyReminderViewModel model,
    DailyReminder reminder,
  ) async {
    final locale = Localizations.localeOf(context);
    final selected = await showTimePicker(
      context: context,
      initialTime: _time(reminder),
      builder: (context, child) => Localizations.override(
        context: context,
        locale: locale,
        child: child,
      ),
    );
    if (selected == null || !mounted) return;
    await model.save(
      enabled: reminder.enabled,
      minutes: selected.hour * 60 + selected.minute,
    );
  }
}
