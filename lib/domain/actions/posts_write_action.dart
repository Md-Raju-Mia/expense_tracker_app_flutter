import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../entities/posts_request.dart';
import '../tasks/posts/posts_task.dart';

class PostsWriteAction extends BaseAction {
  PostsWriteAction(this.task);

  final PostsTask task;
  PostsResponse? result;

  @override
  Future<void> run() async {
    result = await TaskChain.start(() => runTask(task)).execute();
  }
}
