import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/categories/archive_category_task.dart';

class CategoriesArchiveAction extends BaseAction {
  CategoriesArchiveAction(this.task);
  final ArchiveCategoryTask task;

  @override
  Future<void> run() async {
    await TaskChain.start(() => runTask(task)).execute();
  }
}
