import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../l10n/l10n.dart';
import '../view_models/posts_view_model.dart';

class FeedSearch extends StatelessWidget {
  const FeedSearch({required this.model, required this.controller, super.key});

  final PostsViewModel model;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final query = model.query;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          enabled: !model.isFetching,
          textInputAction: TextInputAction.search,
          onSubmitted: model.search,
          decoration: InputDecoration(
            hintText: l.searchPosts,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              tooltip: l.searchPosts,
              onPressed: model.isFetching
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      model.search(controller.text);
                    },
              icon: const Icon(Icons.arrow_forward),
            ),
          ),
        ),
        if (query.search.isNotEmpty || query.tag.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: InputChip(
              label: Text(
                query.tag.isNotEmpty ? '#${query.tag}' : query.search,
              ),
              onDeleted: model.isFetching
                  ? null
                  : () {
                      controller.clear();
                      model.search('');
                    },
              deleteButtonTooltipMessage: l.clearFilter,
            ),
          ),
      ],
    );
  }
}
