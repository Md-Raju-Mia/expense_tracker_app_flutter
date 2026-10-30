import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../l10n/l10n.dart';

class PostAuthor extends StatelessWidget {
  const PostAuthor({required this.userId, super.key});

  final int userId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        const CircleAvatar(child: Icon(Icons.person_outline)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.feedAuthor(userId), style: theme.textTheme.titleMedium),
              Text(
                l.publicPost,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
