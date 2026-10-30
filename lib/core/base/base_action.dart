import 'base_task.dart';

/// An action defines the workflow and runs its tasks.
abstract class BaseAction {
  String? _failedTask;
  String? get failedTask => _failedTask;

  Future<void> run();

  /// Preserve the original exception while identifying the failed step.
  Future<T> runTask<T>(BaseTask<T> task) async {
    _failedTask = null;
    try {
      return await task.run();
    } catch (_) {
      _failedTask = task.name;
      rethrow;
    }
  }
}
