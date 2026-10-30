import '../../domain/entities/feed.dart';
import '../../domain/entities/posts_request.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/remote/feed_remote_data_source.dart';
import '../datasources/remote/posts_remote_data_source.dart';
import '../mappers/feed_mapper.dart';
import '../mappers/posts_request_mapper.dart';

class PostsRepositoryImpl implements PostsRepository {
  const PostsRepositoryImpl(
    this.feedRemoteDataSource,
    this.postsRemoteDataSource,
  );

  final FeedRemoteDataSource feedRemoteDataSource;
  final PostsRemoteDataSource postsRemoteDataSource;

  @override
  Future<FeedPage> loadFeed(
    FeedQuery query, {
    required int skip,
    required int limit,
  }) async {
    final model = await feedRemoteDataSource.loadFeed(
      query,
      skip: skip,
      limit: limit,
    );
    return model.toEntity(query);
  }

  @override
  Future<Post> loadPost(int id) async {
    final model = await feedRemoteDataSource.loadPost(id);
    return model.toEntity();
  }

  @override
  Future<List<PostComment>> loadComments(int postId) async {
    final response = await feedRemoteDataSource.loadComments(postId);
    return List.unmodifiable(
      response.comments.map((model) => model.toEntity()),
    );
  }

  @override
  Future<PostsResponse> execute(PostsRequest request) async {
    final model = await postsRemoteDataSource.execute(request);
    return model.toEntity(request);
  }
}
