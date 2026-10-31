import 'dart:async';

import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';
import 'package:fleet_wise_user_app/domain/actions/preferences_save_action.dart';
import 'package:fleet_wise_user_app/domain/tasks/preferences/load_user_preferences_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/preferences/save_user_preferences_task.dart';
import 'package:fleet_wise_user_app/ui/preferences/view_models/user_preferences_view_model.dart';

class MemoryUserPreferences implements UserPreferencesRepository {
  MemoryUserPreferences([this.saved = const UserPreferences()]);
  UserPreferences saved;
  Object? loadError;
  Object? saveError;
  Completer<void>? pendingSave;
  @override
  Future<UserPreferences> load() async {
    if (loadError != null) throw loadError!;
    return saved;
  }

  @override
  Future<void> save(UserPreferences preferences) async {
    if (saveError != null) throw saveError!;
    if (pendingSave != null) await pendingSave!.future;
    saved = preferences;
  }
}

UserPreferencesViewModel preferencesModel(
  UserPreferencesRepository repository,
) => UserPreferencesViewModel(
  createLoadTask: () => LoadUserPreferencesTask(repository),
  createSaveAction: (preferences) =>
      PreferencesSaveAction(SaveUserPreferencesTask(repository, preferences)),
);
