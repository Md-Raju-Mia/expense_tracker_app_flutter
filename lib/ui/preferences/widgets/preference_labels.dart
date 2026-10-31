import 'package:flutter/material.dart';

import '../../../domain/entities/user_country.dart';
import '../../../domain/entities/user_currency.dart';
import '../../../domain/entities/user_language.dart';
import '../../../l10n/l10n.dart';

String countryLabel(BuildContext context, UserCountry country) =>
    switch (country) {
      UserCountry.bangladesh => context.l10n.preferencesCountryBD,
      UserCountry.india => context.l10n.preferencesCountryIN,
      UserCountry.unitedStates => context.l10n.preferencesCountryUS,
    };

String currencyLabel(BuildContext context, UserCurrency currency) =>
    switch (currency) {
      UserCurrency.bdt => context.l10n.preferencesCurrencyBDT,
      UserCurrency.inr => context.l10n.preferencesCurrencyINR,
      UserCurrency.usd => context.l10n.preferencesCurrencyUSD,
    };

String languageLabel(BuildContext context, UserLanguage language) =>
    switch (language) {
      UserLanguage.bengali => context.l10n.preferencesLanguageBN,
      UserLanguage.english => context.l10n.preferencesLanguageEN,
    };
