import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/expense_theme.dart';
import '../../../l10n/l10n.dart';
import '../../preferences/view_models/user_preferences_view_model.dart';
import '../view_models/expense_home_view_model.dart';

// Keeps saved region settings active across home, form and settings routes.
class ExpenseJourney extends StatefulWidget {
  const ExpenseJourney({super.key, required this.child});
  final Widget child;
  @override
  State<ExpenseJourney> createState() => _ExpenseJourneyState();
}

class _ExpenseJourneyState extends State<ExpenseJourney> {
  UserPreferencesViewModel? _preferences;
  ExpenseHomeViewModel? _home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final preferences = context.read<UserPreferencesViewModel>();
    if (identical(preferences, _preferences)) return;
    _preferences?.removeListener(_applySavedPreferences);
    _preferences = preferences;
    _home = context.read<ExpenseHomeViewModel>();
    preferences.addListener(_applySavedPreferences);
    _applySavedPreferences();
  }

  void _applySavedPreferences() {
    final saved = _preferences?.savedPreferences;
    if (saved != null && _home != null) {
      unawaited(_home!.useCurrency(saved.currency.code));
    }
  }

  @override
  void dispose() {
    _preferences?.removeListener(_applySavedPreferences);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserPreferencesViewModel>();
    final saved = model.savedPreferences;
    if (saved == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: model.contentState.hasError
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.preferencesStorageError,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: model.load,
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(
                      semanticsLabel: context.l10n.loading,
                    ),
            ),
          ),
        ),
      );
    }
    return Localizations.override(
      context: context,
      locale: Locale(saved.language.code),
      child: Theme(data: ExpenseTheme.light, child: widget.child),
    );
  }
}
