import 'package:get_it/get_it.dart';

import '../core/storage/app_preferences.dart';
import '../data/datasources/local/user_preferences_local_data_source.dart';
import '../data/repositories/user_preferences_repository_impl.dart';
import '../domain/actions/preferences_save_action.dart';
import '../domain/entities/user_preferences.dart';
import '../domain/repositories/user_preferences_repository.dart';
import '../domain/tasks/preferences/load_user_preferences_task.dart';
import '../domain/tasks/preferences/save_user_preferences_task.dart';
import '../ui/preferences/view_models/user_preferences_view_model.dart';

void configurePreferencesDependencies(GetIt container) {
  container.registerLazySingleton<UserPreferencesLocalDataSource>(
    () => UserPreferencesLocalDataSource(container<AppPreferences>()),
  );
  container.registerLazySingleton<UserPreferencesRepository>(
    () => UserPreferencesRepositoryImpl(
      container<UserPreferencesLocalDataSource>(),
    ),
  );
  container.registerFactory<LoadUserPreferencesTask>(
    () => LoadUserPreferencesTask(container<UserPreferencesRepository>()),
  );
  container
      .registerFactoryParam<SaveUserPreferencesTask, UserPreferences, void>(
        (preferences, _) => SaveUserPreferencesTask(
          container<UserPreferencesRepository>(),
          preferences,
        ),
      );
  container.registerFactoryParam<PreferencesSaveAction, UserPreferences, void>(
    (preferences, _) => PreferencesSaveAction(
      container<SaveUserPreferencesTask>(param1: preferences),
    ),
  );
  container.registerFactory<UserPreferencesViewModel>(
    () => UserPreferencesViewModel(
      createLoadTask: () => container<LoadUserPreferencesTask>(),
      createSaveAction: (preferences) =>
          container<PreferencesSaveAction>(param1: preferences),
    ),
  );
}
