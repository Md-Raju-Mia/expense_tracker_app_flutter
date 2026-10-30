class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
  });

  final int id, userId, likes, dislikes, views;
  final String title, body;
  final List<String> tags;
}

class FeedQuery {
  const FeedQuery({this.search = '', this.tag = ''});

  final String search, tag;
}

class FeedPage {
  FeedPage({
    required List<Post> posts,
    required this.nextSkip,
    required this.total,
    required this.hasMore,
    required this.query,
  }) : posts = List.unmodifiable(posts);

  final List<Post> posts;
  final int nextSkip, total;
  final bool hasMore;
  final FeedQuery query;
}

class PostComment {
  const PostComment({
    required this.id,
    required this.body,
    required this.author,
    required this.likes,
  });

  final int id, likes;
  final String body, author;
}

class PostDetail {
  const PostDetail(this.post, this.comments);

  final Post post;
  final List<PostComment> comments;
}
