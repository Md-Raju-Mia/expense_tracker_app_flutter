import '../entities/user_preferences.dart';

abstract interface class UserPreferencesRepository {
  Future<UserPreferences> load();
  Future<void> save(UserPreferences preferences);
}
