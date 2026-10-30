import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../domain/entities/feed.dart';
import '../../../l10n/l10n.dart';

class PostMetrics extends StatelessWidget {
  const PostMetrics({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final numbers = NumberFormat.compact(
      locale: Localizations.localeOf(context).toString(),
    );
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        _Metric(
          icon: Icons.favorite_border,
          label: l.feedLikes(numbers.format(post.likes)),
        ),
        _Metric(
          icon: Icons.thumb_down_outlined,
          label: l.feedDislikes(numbers.format(post.dislikes)),
        ),
        _Metric(
          icon: Icons.visibility_outlined,
          label: l.feedViews(numbers.format(post.views)),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSpacing.lg,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(child: Text(label, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
