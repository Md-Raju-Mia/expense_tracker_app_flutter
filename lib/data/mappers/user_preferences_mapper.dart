import '../../domain/entities/user_country.dart';
import '../../domain/entities/user_currency.dart';
import '../../domain/entities/user_language.dart';
import '../../domain/entities/user_preferences.dart';
import '../models/user_preferences_model.dart';

extension UserPreferencesModelMapper on UserPreferencesModel {
  UserPreferences toEntity() {
    return UserPreferences(
      country: UserCountry.values.firstWhere(
        (country) => country.code == countryCode,
      ),
      currency: UserCurrency.values.firstWhere(
        (currency) => currency.code == currencyCode,
      ),
      language: UserLanguage.values.firstWhere(
        (language) => language.code == languageCode,
      ),
    );
  }
}

extension UserPreferencesMapper on UserPreferences {
  UserPreferencesModel toModel() {
    return UserPreferencesModel(
      countryCode: country.code,
      currencyCode: currency.code,
      languageCode: language.code,
    );
  }
}
