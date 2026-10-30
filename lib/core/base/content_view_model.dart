import '../state/content_state.dart';
import 'base_task.dart';
import 'base_view_model.dart';

/// Optional base for screens that load data as well as execute workflows.
abstract class ContentViewModel<T extends Object> extends BaseViewModel {
  ContentState<T> _contentState = ContentState<T>.initialLoading();
  bool _isFetching = false;

  ContentState<T> get contentState => _contentState;

  /// Independent of BaseViewModel.isLoading, which blocks workflow interaction.
  bool get isFetching => _isFetching;

  /// Features define empty results explicitly for their data type.
  bool isEmptyResult(T data);

  /// Reject overlapping fetches; route-owned instances isolate resource changes.
  /// Accepted work completes after disposal without publishing its result.
  Future<ContentState<T>> loadContent(BaseTask<T> task) async {
    if (isDisposed) throw StateError('View model is disposed');
    if (_isFetching) throw StateError('Content is already loading');
    _isFetching = true;
    final previous = _contentState.data;
    _contentState = previous == null
        ? ContentState<T>.initialLoading()
        : ContentState<T>.refreshing(previous);
    notifyListeners();

    late final ContentState<T> outcome;
    try {
      final data = await task.run();
      outcome = isEmptyResult(data)
          ? ContentState<T>.empty(data)
          : ContentState<T>.content(data);
    } catch (error, stackTrace) {
      outcome = ContentState<T>.error(
        error: error,
        stackTrace: stackTrace,
        data: previous,
      );
    } finally {
      _isFetching = false;
    }
    if (!isDisposed) {
      _contentState = outcome;
      notifyListeners();
    }
    return outcome;
  }

  @override
  void dispose() {
    _contentState = ContentState<T>.initialLoading();
    super.dispose();
  }
}
