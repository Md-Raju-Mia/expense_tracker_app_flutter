import 'package:flutter/foundation.dart';

import '../state/action_state.dart';
import 'base_action.dart';

/// Shared presentation state and operation lifecycle for one view.
abstract class BaseViewModel extends ChangeNotifier {
  ActionState _state = const ActionState();
  bool _isLoading = false;
  bool _disposed = false;

  ActionState get state => _state;
  bool get isLoading => _isLoading;
  bool get isDisposed => _disposed;

  /// Diagnostic text only. BaseView formats localized feedback from state.
  String? get errorMessage => _state.error == null
      ? null
      : '${_state.failedTask ?? 'Operation'} failed. Please try again.';

  bool resetState() {
    if (_disposed || isLoading) return false;
    _state = const ActionState();
    notifyListeners();
    return true;
  }

  Future<ActionState> execute(BaseAction action) async {
    if (_disposed) throw StateError('View model is disposed');
    if (isLoading) throw StateError('Another operation is already running');
    _isLoading = true;
    _state = const ActionState(status: ActionStatus.running);
    notifyListeners();

    var outcome = const ActionState(status: ActionStatus.succeeded);
    try {
      await action.run();
    } catch (error, stackTrace) {
      outcome = ActionState(
        status: ActionStatus.failed,
        error: error,
        stackTrace: stackTrace,
        failedTask: action.failedTask,
      );
    } finally {
      _isLoading = false;
      if (!_disposed) {
        _state = outcome;
        notifyListeners();
      }
    }
    return outcome;
  }

  @override
  void dispose() {
    _disposed = true;
    _state = const ActionState();
    super.dispose();
  }
}
