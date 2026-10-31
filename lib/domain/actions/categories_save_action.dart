import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/categories/save_category_task.dart';

class CategoriesSaveAction extends BaseAction {
  CategoriesSaveAction(this.task);
  final SaveCategoryTask task;

  @override
  Future<void> run() async {
    await TaskChain.start(() => runTask(task)).execute();
  }
}
