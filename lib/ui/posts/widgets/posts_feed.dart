import 'package:flutter/material.dart';

import '../../../core/widgets/app_page_content.dart';
import '../../../core/widgets/paging_view.dart';
import '../view_models/posts_view_model.dart';
import 'feed_footer.dart';
import 'feed_header.dart';
import 'post_card.dart';

class PostsFeed extends StatefulWidget {
  const PostsFeed({required this.model, required this.onOpenPost, super.key});

  final PostsViewModel model;
  final ValueChanged<int> onOpenPost;

  @override
  State<PostsFeed> createState() => _PostsFeedState();
}

class _PostsFeedState extends State<PostsFeed> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return AppPageContent(
      scrollable: false,
      padding: EdgeInsets.zero,
      child: PagingView(
        itemCount: model.posts.length,
        resetKey: model.contentState.data?.query,
        canLoadNextPage: model.canLoadMore,
        onLoadNextPage: model.loadMore,
        onRefresh: model.refresh,
        header: FeedHeader(model: model, searchController: _searchController),
        itemBuilder: (context, index) {
          final post = model.posts[index];
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            onOpen: () => widget.onOpenPost(post.id),
            onTag: model.isFetching
                ? null
                : (tag) {
                    _searchController.clear();
                    model.filterTag(tag);
                  },
          );
        },
        footer: FeedFooter(model: model),
      ),
    );
  }
}
