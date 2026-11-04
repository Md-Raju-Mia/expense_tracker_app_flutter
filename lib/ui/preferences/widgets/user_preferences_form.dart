import 'package:flutter/material.dart';

import '../../../domain/entities/user_country.dart';
import '../../../domain/entities/user_currency.dart';
import '../../../domain/entities/user_language.dart';
import '../../../l10n/l10n.dart';
import '../view_models/user_preferences_view_model.dart';
import 'preference_choice_field.dart';
import 'preference_labels.dart';

class UserPreferencesForm extends StatelessWidget {
  const UserPreferencesForm({
    super.key,
    required this.model,
    required this.onSave,
    required this.reminderSection,
  });
  final UserPreferencesViewModel model;
  final VoidCallback onSave;
  final Widget reminderSection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = context.l10n;
    final draft = model.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 28,
              color: colors.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          text.preferencesTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text.preferencesIntro,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        PreferenceChoiceField<UserCountry>(
          label: text.preferencesCountry,
          value: draft.country,
          values: UserCountry.values,
          labelFor: (country) => countryLabel(context, country),
          onChanged: model.selectCountry,
          helper: text.preferencesCountryHint,
        ),
        const SizedBox(height: 24),
        PreferenceChoiceField<UserCurrency>(
          label: text.preferencesCurrency,
          value: draft.currency,
          values: UserCurrency.values,
          labelFor: (currency) => currencyLabel(context, currency),
          onChanged: model.selectCurrency,
          helper: text.preferencesCurrencyHint,
        ),
        const SizedBox(height: 24),
        PreferenceChoiceField<UserLanguage>(
          label: text.preferencesLanguage,
          value: draft.language,
          values: UserLanguage.values,
          labelFor: (language) => languageLabel(context, language),
          onChanged: model.selectLanguage,
        ),
        const SizedBox(height: 24),
        Text(
          text.preferencesSupportHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: model.isLoading ? null : onSave,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          icon: const Icon(Icons.check_rounded),
          label: Text(
            text.preferencesSave,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        reminderSection,
      ],
    );
  }
}
