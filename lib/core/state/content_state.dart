enum ContentStatus { initialLoading, content, empty, refreshing, error }

/// Data-loading state, independent of workflow ActionState.
/// A non-null data value may itself represent an empty result.
class ContentState<T extends Object> {
  const ContentState.initialLoading()
    : status = ContentStatus.initialLoading,
      data = null,
      error = null,
      stackTrace = null;

  const ContentState.content(T this.data)
    : status = ContentStatus.content,
      error = null,
      stackTrace = null;

  const ContentState.empty(T this.data)
    : status = ContentStatus.empty,
      error = null,
      stackTrace = null;

  const ContentState.refreshing(T this.data)
    : status = ContentStatus.refreshing,
      error = null,
      stackTrace = null;

  const ContentState.error({
    required Object this.error,
    this.stackTrace,
    this.data,
  }) : status = ContentStatus.error;

  final ContentStatus status;
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;

  bool get hasData => data != null;
  bool get isInitialLoading => status == ContentStatus.initialLoading;
  bool get isRefreshing => status == ContentStatus.refreshing;
  bool get isEmpty => status == ContentStatus.empty;
  bool get hasError => status == ContentStatus.error;
}
