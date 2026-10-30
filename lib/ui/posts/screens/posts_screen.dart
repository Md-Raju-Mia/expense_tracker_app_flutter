import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/base/base_view.dart';
import '../../../l10n/l10n.dart';
import '../../../routes/app_pages.dart';
import '../view_models/posts_view_model.dart';
import '../widgets/posts_feed.dart';

class PostsScreen extends BaseView<PostsViewModel> {
  const PostsScreen({super.key});

  @override
  PreferredSizeWidget appBar(BuildContext context, PostsViewModel viewModel) =>
      AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.refreshFeed,
            onPressed: viewModel.isFetching ? null : viewModel.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      );

  @override
  Widget body(BuildContext context, PostsViewModel viewModel) => PostsFeed(
    model: viewModel,
    onOpenPost: (postId) => context.pushNamed(
      Routes.POST_DETAIL,
      pathParameters: {'postId': postId.toString()},
    ),
  );
}
