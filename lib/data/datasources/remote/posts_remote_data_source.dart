import '../../../core/base/base_remote_data_source.dart';
import '../../../domain/entities/posts_request.dart';
import '../../models/posts_request_model.dart';

class PostsRemoteDataSource extends BaseRemoteDataSource {
  const PostsRemoteDataSource(super.apiClient);

  Future<PostsResponseModel> execute(PostsRequest request) async {
    final model = PostsRequestModel.fromDomain(request);
    var statusCode = 0;
    return callApi(
      () async {
        final response = await apiClient.request<dynamic>(
          model.path,
          method: model.method,
          queryParameters: model.parameters,
          data: model.payload,
        );
        statusCode = response.statusCode ?? 0;
        return response;
      },
      decode: (data) {
        final operation = request.operation;
        if (operation == PostsOperation.tags ||
            operation == PostsOperation.tagList) {
          if (data is! List ||
              data.any(
                (value) => operation == PostsOperation.tagList
                    ? value is! String
                    : value is! Map<String, dynamic> ||
                          value['slug'] is! String ||
                          value['name'] is! String,
              )) {
            throw const FormatException('Invalid tags');
          }
        } else {
          if (data is! Map<String, dynamic>) {
            throw const FormatException('Expected object');
          }
          if (const {
            PostsOperation.list,
            PostsOperation.search,
            PostsOperation.byTag,
            PostsOperation.byUser,
            PostsOperation.comments,
          }.contains(operation)) {
            final items =
                data[operation == PostsOperation.comments
                    ? 'comments'
                    : 'posts'];
            if (items is! List ||
                data['total'] is! int ||
                data['skip'] is! int ||
                data['limit'] is! int ||
                items.any(
                  (value) =>
                      value is! Map<String, dynamic> || value['id'] is! int,
                )) {
              throw const FormatException('Invalid page');
            }
          } else if (data['id'] is! int || data['title'] is! String) {
            throw const FormatException('Invalid post');
          }
          if (operation == PostsOperation.delete &&
              (data['isDeleted'] != true || data['deletedOn'] is! String)) {
            throw const FormatException('Invalid deletion');
          }
        }
        return PostsResponseModel(data: data as Object, statusCode: statusCode);
      },
    );
  }
}
