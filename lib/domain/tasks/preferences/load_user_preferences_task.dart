import '../../../core/base/base_task.dart';
import '../../entities/user_preferences.dart';
import '../../repositories/user_preferences_repository.dart';

class LoadUserPreferencesTask extends BaseTask<UserPreferences> {
  const LoadUserPreferencesTask(this.repository);
  final UserPreferencesRepository repository;
  @override
  String get name => 'Load preferences';
  @override
  Future<UserPreferences> run() => repository.load();
}
