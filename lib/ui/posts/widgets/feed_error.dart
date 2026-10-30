import 'package:flutter/material.dart';

import '../../../core/presentation/error_message.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../l10n/l10n.dart';

class FeedError extends StatelessWidget {
  const FeedError({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Text(
            localizedErrorMessage(l, error, operation: l.loadingPosts),
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l.retry),
          ),
        ],
      ),
    );
  }
}
