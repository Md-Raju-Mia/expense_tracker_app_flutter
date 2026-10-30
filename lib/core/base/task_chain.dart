import 'dart:async';

/// A lazy, typed pipeline. Each step receives the preceding step's output.
class TaskChain<T> {
  TaskChain.start(FutureOr<T> Function() first)
    : _run = (() => Future<T>.sync(first));

  TaskChain._(this._run);

  final Future<T> Function() _run;

  TaskChain<R> add<R>(FutureOr<R> Function(T value) next) =>
      TaskChain<R>._(() async => next(await _run()));

  /// Runs the entire pipeline, returning its final output.
  /// Each call starts a fresh execution; errors stop subsequent steps.
  Future<T> execute() => _run();
}
