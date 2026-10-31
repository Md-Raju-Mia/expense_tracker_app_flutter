import 'dart:convert';

import '../../../core/storage/app_preferences.dart';
import '../../models/user_preferences_model.dart';

class UserPreferencesLocalDataSource {
  UserPreferencesLocalDataSource(this.storage);
  final AppPreferences storage;
  static const storageKey = 'user_preferences_v1';

  Future<UserPreferencesModel?> load() async {
    final saved = await storage.getString(storageKey);
    if (saved == null) return null;
    return UserPreferencesModel.fromJson(
      jsonDecode(saved) as Map<String, dynamic>,
    );
  }

  Future<void> save(UserPreferencesModel preferences) {
    // Save one record so country, currency and language cannot become mixed.
    return storage.setString(storageKey, jsonEncode(preferences.toJson()));
  }
}
