enum PostsOperation {
  list,
  single,
  search,
  tags,
  tagList,
  byTag,
  byUser,
  comments,
  add,
  update,
  delete,
}

class PostsRequest {
  const PostsRequest({
    this.operation = PostsOperation.list,
    this.id = 1,
    this.query = '',
    this.limit = 10,
    this.skip = 0,
    this.sortBy = 'id',
    this.order = 'asc',
    this.select = '',
    this.title = '',
    this.body = '',
    this.userId = 1,
  });

  final PostsOperation operation;
  final int id, limit, skip, userId;
  final String query, sortBy, order, select, title, body;

  bool get isWrite => const {
    PostsOperation.add,
    PostsOperation.update,
    PostsOperation.delete,
  }.contains(operation);
}

class PostsResponse {
  const PostsResponse(this.request, this.data, this.statusCode);

  final PostsRequest request;
  final Object data;
  final int statusCode;

  List<dynamic> get items => switch (data) {
    List<dynamic> values => values,
    Map<String, dynamic> values =>
      (values['posts'] ?? values['comments'] ?? [values]) as List<dynamic>,
    _ => [],
  };
}
