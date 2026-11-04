import 'package:get_it/get_it.dart';

import '../core/utils/platform/android_daily_reminder.dart';
import '../data/repositories/daily_reminder_repository_impl.dart';
import '../domain/actions/reminder_save_action.dart';
import '../domain/repositories/daily_reminder_repository.dart';
import '../domain/tasks/reminder/load_daily_reminder_task.dart';
import '../domain/tasks/reminder/save_daily_reminder_task.dart';
import '../ui/preferences/view_models/daily_reminder_view_model.dart';

void configureReminderDependencies(GetIt container) {
  container.registerLazySingleton<DailyReminderRepository>(
    () => const DailyReminderRepositoryImpl(AndroidDailyReminder()),
  );
  container.registerFactory<LoadDailyReminderTask>(
    () => LoadDailyReminderTask(container<DailyReminderRepository>()),
  );
  container.registerFactoryParam<SaveDailyReminderTask, bool, int>(
    (enabled, minutes) => SaveDailyReminderTask(
      container<DailyReminderRepository>(),
      enabled,
      minutes,
    ),
  );
  container.registerFactoryParam<ReminderSaveAction, bool, int>(
    (enabled, minutes) => ReminderSaveAction(
      container<SaveDailyReminderTask>(param1: enabled, param2: minutes),
    ),
  );
  container.registerFactory<DailyReminderViewModel>(
    () => DailyReminderViewModel(
      container<LoadDailyReminderTask>(),
      (enabled, minutes) =>
          container<ReminderSaveAction>(param1: enabled, param2: minutes),
    ),
  );
}
