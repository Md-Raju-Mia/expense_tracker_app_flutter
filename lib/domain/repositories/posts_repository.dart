import '../entities/feed.dart';
import '../entities/posts_request.dart';

abstract interface class PostsRepository {
  Future<FeedPage> loadFeed(
    FeedQuery query, {
    required int skip,
    required int limit,
  });

  Future<Post> loadPost(int id);

  Future<List<PostComment>> loadComments(int postId);

  Future<PostsResponse> execute(PostsRequest request);
}
