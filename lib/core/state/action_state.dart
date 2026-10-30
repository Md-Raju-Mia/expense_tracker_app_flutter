enum ActionStatus { idle, running, succeeded, failed }

class ActionState {
  const ActionState({
    this.status = ActionStatus.idle,
    this.error,
    this.stackTrace,
    this.failedTask,
  });

  final ActionStatus status;
  final Object? error;
  final StackTrace? stackTrace;
  final String? failedTask;

  bool get isRunning => status == ActionStatus.running;

  bool get isSuccess => status == ActionStatus.succeeded;
}
