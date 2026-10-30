import '../../../core/base/base_remote_data_source.dart';
import '../../../domain/entities/feed.dart';
import '../../models/feed_model.dart';
import '../../models/json_model_decoder.dart';

class FeedRemoteDataSource extends BaseRemoteDataSource {
  const FeedRemoteDataSource(super.apiClient);

  Future<FeedResponseModel> loadFeed(
    FeedQuery query, {
    required int skip,
    required int limit,
  }) => callApi(
    () => apiClient.request<dynamic>(
      query.search.isNotEmpty
          ? 'posts/search'
          : query.tag.isNotEmpty
          ? 'posts/tag/${Uri.encodeComponent(query.tag)}'
          : 'posts',
      queryParameters: {
        'limit': limit,
        'skip': skip,
        if (query.search.isNotEmpty) 'q': query.search,
      },
    ),
    decode: (value) {
      final model = decodeJsonObject(value, FeedResponseModel.fromJson);
      if (model.skip != skip) {
        throw const FormatException('Unexpected posts page offset');
      }
      return model;
    },
  );

  Future<PostModel> loadPost(int id) => callApi(
    () => apiClient.request<dynamic>('posts/$id'),
    decode: (value) => decodeJsonObject(value, PostModel.fromJson),
  );

  Future<CommentsResponseModel> loadComments(int postId) => callApi(
    () => apiClient.request<dynamic>(
      'posts/$postId/comments',
      queryParameters: {'limit': 0},
    ),
    decode: (value) => decodeJsonObject(value, CommentsResponseModel.fromJson),
  );
}
