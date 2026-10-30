// The public constructor argument intentionally initializes a private factory.
// ignore_for_file: prefer_initializing_formals

import '../../../core/base/base_task.dart';
import '../../../core/base/content_view_model.dart';
import '../../../domain/entities/feed.dart';

typedef FeedTaskFactory = BaseTask<FeedPage> Function(
  FeedQuery query,
  FeedPage? previous,
);

class PostsViewModel extends ContentViewModel<FeedPage> {
  PostsViewModel({required FeedTaskFactory createFeedTask})
    : _createFeedTask = createFeedTask;
  final FeedTaskFactory _createFeedTask;
  Future<void>? _pending;
  FeedQuery _requestedQuery = const FeedQuery();
  bool _appending = false;
  bool get isLoadingMore => isFetching && _appending;
  bool get appendFailed => _appending && contentState.hasError;
  bool get canLoadMore =>
      !isDisposed &&
      !isFetching &&
      !contentState.hasError &&
      (contentState.data?.hasMore ?? false);
  List<Post> get posts => contentState.data?.posts ?? const [];
  FeedQuery get query => contentState.data?.query ?? _requestedQuery;
  @override
  bool isEmptyResult(FeedPage data) => data.posts.isEmpty;
  Future<void> initialize() => contentState.hasData || isFetching
      ? Future.value()
      : _load(const FeedQuery());
  Future<void> refresh() async {
    // Finish an accepted append before replacing the feed from offset zero.
    await _pending;
    if (isDisposed || isFetching) return;
    await _load(query);
  }

  Future<void> search(String text) => _load(FeedQuery(search: text.trim()));
  Future<void> filterTag(String tag) => _load(FeedQuery(tag: tag));
  Future<void> loadMore() =>
      canLoadMore ? _load(query, append: true) : Future.value();
  Future<void> retry() => _load(_requestedQuery, append: _appending);
  Future<void> _load(FeedQuery requested, {bool append = false}) {
    if (isDisposed || isFetching) return Future.value();
    _requestedQuery = requested;
    _appending = append;
    final previous = append ? contentState.data : null;
    final task = _createFeedTask(requested, previous);
    final pending = loadContent(task).then<void>((_) {});
    _pending = pending;
    return pending;
  }
}
