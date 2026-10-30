import 'package:flutter/material.dart';

import '../../../core/presentation/error_message.dart';
import '../../../core/widgets/app_page_content.dart';
import '../../../l10n/l10n.dart';
import '../view_models/post_detail_view_model.dart';
import 'post_card.dart';
import 'post_comments.dart';

class PostDetailContent extends StatelessWidget {
  const PostDetailContent({required this.model, super.key});

  final PostDetailViewModel model;

  @override
  Widget build(BuildContext context) {
    final state = model.contentState;
    final detail = state.data;
    final l = context.l10n;
    return AppPageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.isInitialLoading)
            Center(
              child: CircularProgressIndicator(semanticsLabel: l.loadingPosts),
            ),
          if (state.hasError) ...[
            Text(
              localizedErrorMessage(l, state.error!, operation: l.loadingPosts),
            ),
            TextButton(onPressed: model.load, child: Text(l.retry)),
          ],
          if (detail != null) ...[
            PostCard(post: detail.post),
            PostComments(comments: detail.comments),
          ],
        ],
      ),
    );
  }
}
