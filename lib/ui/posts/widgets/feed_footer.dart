import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../l10n/l10n.dart';
import '../view_models/posts_view_model.dart';
import 'feed_error.dart';

class FeedFooter extends StatelessWidget {
  const FeedFooter({required this.model, super.key});

  final PostsViewModel model;

  @override
  Widget build(BuildContext context) {
    final state = model.contentState;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          if (state.isInitialLoading || model.isLoadingMore) ...[
            CircularProgressIndicator(semanticsLabel: l.loadingPosts),
            const SizedBox(height: AppSpacing.md),
            Text(l.loadingPosts),
          ] else if (model.appendFailed)
            FeedError(error: state.error!, onRetry: model.retry)
          else if (state.isEmpty) ...[
            const Icon(Icons.forum_outlined),
            const SizedBox(height: AppSpacing.md),
            Text(l.noPosts),
          ] else if (state.hasData && !state.data!.hasMore) ...[
            const Icon(Icons.check_circle_outline),
            const SizedBox(height: AppSpacing.sm),
            Text(l.feedEnd),
          ],
        ],
      ),
    );
  }
}
