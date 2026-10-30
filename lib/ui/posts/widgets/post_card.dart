import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../domain/entities/feed.dart';
import '../../../l10n/l10n.dart';
import 'post_actions.dart';
import 'post_author.dart';
import 'post_metrics.dart';
import 'post_tags.dart';

class PostCard extends StatelessWidget {
  const PostCard({required this.post, this.onOpen, this.onTag, super.key});

  final Post post;
  final VoidCallback? onOpen;
  final ValueChanged<String>? onTag;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostAuthor(userId: post.userId),
            const SizedBox(height: AppSpacing.lg),
            Text(post.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              post.body,
              maxLines: onOpen == null ? null : 5,
              overflow: onOpen == null ? null : TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge,
            ),
            if (onOpen != null)
              TextButton(onPressed: onOpen, child: Text(l.readPost)),
            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              PostTags(tags: post.tags, onTag: onTag),
            ],
            const SizedBox(height: AppSpacing.md),
            PostMetrics(post: post),
            const Divider(height: AppSpacing.xl),
            PostActions(postId: post.id, onOpen: onOpen),
          ],
        ),
      ),
    );
  }
}
