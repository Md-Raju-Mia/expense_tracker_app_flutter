import 'user_country.dart';
import 'user_currency.dart';
import 'user_language.dart';

class UserPreferences {
  const UserPreferences({
    this.country = UserCountry.bangladesh,
    this.currency = UserCurrency.bdt,
    this.language = UserLanguage.bengali,
  });

  factory UserPreferences.forCountry(UserCountry country) {
    return UserPreferences(
      country: country,
      currency: country.currency,
      language: country.language,
    );
  }

  final UserCountry country;
  final UserCurrency currency;
  final UserLanguage language;
}
