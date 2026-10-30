import '../../core/base/base_task.dart';
import '../entities/posts_request.dart';
import '../repositories/posts_repository.dart';

class PostsTask extends BaseTask<PostsResponse> {
  const PostsTask(this.repository, this.request);

  final PostsRepository repository;
  final PostsRequest request;

  @override
  String get name => '${request.operation.name} posts';

  @override
  Future<PostsResponse> run() => repository.execute(request);
}
