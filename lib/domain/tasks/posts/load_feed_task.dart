import '../../../core/base/base_task.dart';
import '../../../core/base/task_chain.dart';
import '../../entities/feed.dart';
import '../../repositories/posts_repository.dart';

/// One request returns an accumulated snapshot. Offsets count server rows,
/// including duplicates, while the rendered collection contains unique IDs.
class LoadFeedTask extends BaseTask<FeedPage> {
  const LoadFeedTask(
    this.repository, {
    required this.query,
    this.previous,
    this.limit = 10,
  });

  final PostsRepository repository;
  final FeedQuery query;
  final FeedPage? previous;
  final int limit;

  @override
  String get name => 'Load posts';

  @override
  Future<FeedPage> run() async {
    final page = await repository.loadFeed(
      query,
      skip: previous?.nextSkip ?? 0,
      limit: limit,
    );
    final byId = {
      for (final post in previous?.posts ?? <Post>[]) post.id: post,
    };
    for (final post in page.posts) {
      byId[post.id] = post;
    }
    return FeedPage(
      posts: byId.values.toList(),
      nextSkip: page.nextSkip,
      total: page.total,
      hasMore: page.hasMore,
      query: query,
    );
  }
}

class LoadPostDetailTask extends BaseTask<PostDetail> {
  const LoadPostDetailTask(this.repository, this.id);

  final PostsRepository repository;
  final int id;

  @override
  String get name => 'Load post and comments';

  @override
  Future<PostDetail> run() => TaskChain.start(() => repository.loadPost(id))
      .add((post) async => PostDetail(post, await repository.loadComments(id)))
      .execute();
}
