import '../../../core/base/base_task.dart';
import '../../entities/user_preferences.dart';
import '../../repositories/user_preferences_repository.dart';

class SaveUserPreferencesTask extends BaseTask<void> {
  const SaveUserPreferencesTask(this.repository, this.preferences);
  final UserPreferencesRepository repository;
  final UserPreferences preferences;
  @override
  String get name => 'Save preferences';
  @override
  Future<void> run() => repository.save(preferences);
}
