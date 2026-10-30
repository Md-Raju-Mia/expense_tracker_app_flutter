import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/posts_request.dart';

part 'posts_request_model.freezed.dart';
part 'posts_request_model.g.dart';

@freezed
abstract class PostsRequestModel with _$PostsRequestModel {
  const PostsRequestModel._();

  const factory PostsRequestModel({
    required PostsOperation operation,
    required int id,
    required String query,
    required int limit,
    required int skip,
    required String sortBy,
    required String order,
    required String select,
    required String title,
    required String body,
    required int userId,
  }) = _PostsRequestModel;

  factory PostsRequestModel.fromDomain(PostsRequest request) =>
      PostsRequestModel(
        operation: request.operation,
        id: request.id,
        query: request.query,
        limit: request.limit,
        skip: request.skip,
        sortBy: request.sortBy,
        order: request.order,
        select: request.select,
        title: request.title,
        body: request.body,
        userId: request.userId,
      );

  factory PostsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PostsRequestModelFromJson(json);

  String get method => switch (operation) {
    PostsOperation.add => 'POST',
    PostsOperation.update => 'PATCH',
    PostsOperation.delete => 'DELETE',
    _ => 'GET',
  };

  String get path => switch (operation) {
    PostsOperation.list => 'posts',
    PostsOperation.single ||
    PostsOperation.update ||
    PostsOperation.delete => 'posts/$id',
    PostsOperation.search => 'posts/search',
    PostsOperation.tags => 'posts/tags',
    PostsOperation.tagList => 'posts/tag-list',
    PostsOperation.byTag => 'posts/tag/${Uri.encodeComponent(query)}',
    PostsOperation.byUser => 'posts/user/$id',
    PostsOperation.comments => 'posts/$id/comments',
    PostsOperation.add => 'posts/add',
  };

  Map<String, dynamic> get parameters => switch (operation) {
    PostsOperation.list ||
    PostsOperation.search ||
    PostsOperation.byTag ||
    PostsOperation.byUser ||
    PostsOperation.comments => {
      'limit': limit,
      'skip': skip,
      if (operation == PostsOperation.list) ...{
        'sortBy': sortBy,
        'order': order,
      },
      if (operation == PostsOperation.search) 'q': query,
      if (select.isNotEmpty && operation != PostsOperation.comments)
        'select': select,
    },
    _ => {},
  };

  Map<String, dynamic>? get payload => switch (operation) {
    PostsOperation.add => {'title': title, 'body': body, 'userId': userId},
    PostsOperation.update => {'title': title, 'body': body},
    _ => null,
  };

  String get endpoint => Uri.parse(path)
      .replace(
        queryParameters: parameters.isEmpty
            ? null
            : parameters.map((key, value) => MapEntry(key, '$value')),
      )
      .toString();
}

@freezed
abstract class PostsResponseModel with _$PostsResponseModel {
  const factory PostsResponseModel({
    required Object data,
    required int statusCode,
  }) = _PostsResponseModel;

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostsResponseModelFromJson(json);
}
