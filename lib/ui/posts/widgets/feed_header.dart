import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../l10n/l10n.dart';
import '../view_models/posts_view_model.dart';
import 'feed_error.dart';
import 'feed_search.dart';

class FeedHeader extends StatelessWidget {
  const FeedHeader({
    required this.model,
    required this.searchController,
    super.key,
  });

  final PostsViewModel model;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final state = model.contentState;
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.yourFeed, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l.feedIntro,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FeedSearch(model: model, controller: searchController),
        const SizedBox(height: AppSpacing.xl),
        if (state.hasError && !model.appendFailed)
          FeedError(error: state.error!, onRetry: model.retry),
        if (state.isRefreshing && !model.isLoadingMore)
          const LinearProgressIndicator(),
      ],
    );
  }
}
