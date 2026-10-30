import '../../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../presentation/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

/// Shared screen shell. The ancestor Provider owns the view model lifecycle.
/// Views render state and forward user intent; actions remain in the view model.
abstract class BaseView<T extends BaseViewModel> extends StatelessWidget {
  const BaseView({super.key});

  Widget body(BuildContext context, T viewModel);

  PreferredSizeWidget? appBar(BuildContext context, T viewModel) => null;

  Widget? floatingActionButton(BuildContext context, T viewModel) => null;

  Widget? bottomNavigationBar(BuildContext context, T viewModel) => null;

  Widget? drawer(BuildContext context, T viewModel) => null;

  Color? backgroundColor(BuildContext context) => null;

  Widget loading(BuildContext context, T viewModel) => Center(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: CircularProgressIndicator(semanticsLabel: context.l10n.loading),
      ),
    ),
  );

  /// Persistent feedback avoids snackbar side effects during widget builds.
  Widget error(BuildContext context, T viewModel, String message) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        color: colors.errorContainer,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onErrorContainer),
        ),
      ),
    );
  }

  /// Override in the feature view; never expose raw diagnostic task names.
  String operationLabel(BuildContext context, String? failedTask) =>
      context.l10n.operation;

  /// Override for feature-specific failures, or return null to hide feedback.
  /// Called during build so messages follow the current locale.
  String? errorMessage(BuildContext context, T viewModel) {
    final failure = viewModel.state.error;
    if (failure == null) return null;
    return localizedErrorMessage(
      context.l10n,
      failure,
      operation: operationLabel(context, viewModel.state.failedTask),
    );
  }

  Widget pageContent(BuildContext context, T viewModel) {
    final message = errorMessage(context, viewModel);
    return SafeArea(
      child: Column(
        children: [
          if (message != null && message.isNotEmpty)
            error(context, viewModel, message),
          Expanded(child: body(context, viewModel)),
        ],
      ),
    );
  }

  Widget pageScaffold(BuildContext context, T viewModel) => Scaffold(
    backgroundColor: backgroundColor(context),
    appBar: appBar(context, viewModel),
    body: pageContent(context, viewModel),
    floatingActionButton: floatingActionButton(context, viewModel),
    bottomNavigationBar: bottomNavigationBar(context, viewModel),
    drawer: drawer(context, viewModel),
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<T>();
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeFocus(
          excluding: viewModel.isLoading,
          child: ExcludeSemantics(
            excluding: viewModel.isLoading,
            child: pageScaffold(context, viewModel),
          ),
        ),
        if (viewModel.isLoading) ...[
          ModalBarrier(
            dismissible: false,
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.32),
          ),
          loading(context, viewModel),
        ],
      ],
    );
  }
}
