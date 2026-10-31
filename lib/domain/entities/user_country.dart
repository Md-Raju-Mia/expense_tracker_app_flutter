import 'user_currency.dart';
import 'user_language.dart';

enum UserCountry {
  bangladesh('BD', UserCurrency.bdt, UserLanguage.bengali),
  india('IN', UserCurrency.inr, UserLanguage.english),
  unitedStates('US', UserCurrency.usd, UserLanguage.english);

  const UserCountry(this.code, this.currency, this.language);
  final String code;
  final UserCurrency currency;
  final UserLanguage language;
}
