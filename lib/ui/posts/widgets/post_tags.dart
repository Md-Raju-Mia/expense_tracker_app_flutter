import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';

class PostTags extends StatelessWidget {
  const PostTags({required this.tags, this.onTag, super.key});

  final List<String> tags;
  final ValueChanged<String>? onTag;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.xs,
    children: [
      for (final tag in tags)
        if (onTag == null)
          Chip(label: Text('#$tag'))
        else
          ActionChip(label: Text('#$tag'), onPressed: () => onTag!(tag)),
    ],
  );
}
