import '../../core/base/base_action.dart';
import '../../core/base/task_chain.dart';
import '../tasks/preferences/save_user_preferences_task.dart';

class PreferencesSaveAction extends BaseAction {
  PreferencesSaveAction(this.task);
  final SaveUserPreferencesTask task;
  @override
  Future<void> run() async {
    await TaskChain.start(() => runTask(task)).execute();
  }
}
