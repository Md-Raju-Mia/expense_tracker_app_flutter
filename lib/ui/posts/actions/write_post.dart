import '../../../core/base/base_action.dart';
import '../../../domain/entities/posts_request.dart';
import '../../../domain/tasks/posts_task.dart';

class WritePost extends BaseAction {
  WritePost(this.task);

  final PostsTask task;
  PostsResponse? result;

  @override
  Future<void> run() async {
    result = await runTask(task);
  }
}
