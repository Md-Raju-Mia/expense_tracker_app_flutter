import '../../domain/entities/posts_request.dart';
import '../models/posts_request_model.dart';

extension PostsResponseModelMapper on PostsResponseModel {
  PostsResponse toEntity(PostsRequest request) =>
      PostsResponse(request, data, statusCode);
}
