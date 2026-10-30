import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../l10n/l10n.dart';

class PostActions extends StatelessWidget {
  const PostActions({required this.postId, this.onOpen, super.key});

  final int postId;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        if (onOpen != null)
          TextButton.icon(
            onPressed: onOpen,
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(l.comments),
          ),
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: 'https://dummyjson.com/posts/$postId'),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(l.postLinkCopied)));
            }
          },
          icon: const Icon(Icons.link),
          label: Text(l.copyPostLink),
        ),
      ],
    );
  }
}
