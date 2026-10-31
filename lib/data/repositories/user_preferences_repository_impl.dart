import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../datasources/local/user_preferences_local_data_source.dart';
import '../mappers/user_preferences_mapper.dart';

class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  UserPreferencesRepositoryImpl(this.source);
  final UserPreferencesLocalDataSource source;

  @override
  Future<UserPreferences> load() async {
    final model = await source.load();
    return model?.toEntity() ?? const UserPreferences();
  }

  @override
  Future<void> save(UserPreferences preferences) =>
      source.save(preferences.toModel());
}
