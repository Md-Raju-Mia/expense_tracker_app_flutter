import '../../domain/entities/feed.dart';
import '../models/feed_model.dart';

extension PostModelMapper on PostModel {
  Post toEntity() => Post(
    id: id,
    userId: userId,
    title: title,
    body: body,
    tags: List.unmodifiable(tags),
    likes: reactions.likes,
    dislikes: reactions.dislikes,
    views: views,
  );
}

extension FeedResponseModelMapper on FeedResponseModel {
  FeedPage toEntity(FeedQuery query) {
    final nextSkip = skip + posts.length;
    return FeedPage(
      posts: posts.map((post) => post.toEntity()).toList(),
      nextSkip: nextSkip,
      total: total,
      hasMore: posts.isNotEmpty && nextSkip < total,
      query: query,
    );
  }
}

extension PostCommentModelMapper on PostCommentModel {
  PostComment toEntity() =>
      PostComment(id: id, body: body, author: user.fullName, likes: likes);
}
