import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view.dart';
import '../../../core/state/action_state.dart';
import '../../../core/widgets/app_page_content.dart';
import '../../../domain/entities/user_preferences.dart';
import '../../../l10n/l10n.dart';
import '../view_models/user_preferences_view_model.dart';
import '../widgets/ads_privacy_button.dart';
import '../widgets/user_preferences_form.dart';

class UserPreferencesScreen extends BaseView<UserPreferencesViewModel> {
  const UserPreferencesScreen({
    super.key,
    required this.onSaved,
    this.reminderSection = const SizedBox.shrink(),
  });
  final ValueChanged<UserPreferences> onSaved;
  final Widget reminderSection;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserPreferencesViewModel>();
    // Preview the selected language without changing application-wide settings.
    return Localizations.override(
      context: context,
      locale: Locale(model.draft.language.code),
      child: Builder(builder: (context) => super.build(context)),
    );
  }

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    UserPreferencesViewModel viewModel,
  ) => AppBar(title: Text(context.l10n.preferencesAppBar));

  @override
  String operationLabel(BuildContext context, String? failedTask) =>
      context.l10n.preferencesSave;

  @override
  String? errorMessage(
    BuildContext context,
    UserPreferencesViewModel viewModel,
  ) {
    if (viewModel.contentState.hasError || viewModel.state.error != null) {
      return context.l10n.preferencesStorageError;
    }
    return null;
  }

  @override
  Widget body(BuildContext context, UserPreferencesViewModel viewModel) {
    if (!viewModel.contentState.hasData) {
      if (viewModel.contentState.hasError) {
        return Center(
          child: FilledButton.icon(
            onPressed: viewModel.load,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(semanticsLabel: context.l10n.loading),
      );
    }
    return AppPageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserPreferencesForm(
            model: viewModel,
            reminderSection: reminderSection,
            onSave: () async {
              final selected = viewModel.draft;
              final outcome = await viewModel.save();
              if (context.mounted && outcome.status == ActionStatus.succeeded) {
                onSaved(selected);
              }
            },
          ),
          const AdsPrivacyButton(),
        ],
      ),
    );
  }
}
