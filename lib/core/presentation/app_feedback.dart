import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

enum AppFeedbackKind { success, info, warning }

/// Shows transient, non-error feedback from presentation code.
abstract final class AppFeedback {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    AppFeedbackKind kind = AppFeedbackKind.info,
    SnackBarAction? action,
  }) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground, icon) = switch (kind) {
      AppFeedbackKind.success => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        Icons.check_circle_outline,
      ),
      AppFeedbackKind.info => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        Icons.info_outline,
      ),
      AppFeedbackKind.warning => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
        Icons.warning_amber_outlined,
      ),
    };
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        backgroundColor: background,
        action: action,
        content: Semantics(
          liveRegion: true,
          child: Row(
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(message, style: TextStyle(color: foreground)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
