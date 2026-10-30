# Posts social feed

A Flutter social reading screen backed by the [DummyJSON posts API](https://dummyjson.com/docs/posts), using Provider MVVM, get_it, go_router, and the shared Dio client.

## Use the app

Open the app to load the first ten posts automatically. Scroll to discover more,
pull down or use the refresh icon to reload, search for words, or tap a tag to
filter the feed. Read post / Comments opens the complete post and its comments.
Returning keeps the feed's loaded posts and scroll position. Copy link copies
the public DummyJSON post URL.

Cards show the post title, body, tags, and the reaction/view counts returned by
the server. Authors are labeled with their actual user ID because the posts
endpoint does not include names or photos. Counts are read-only; no fabricated
like, follow, or notification actions are shown. English/Bengali and system
light/dark themes are supported.

## Pagination and architecture

The implementation follows the separation in the supplied
[PagingController](https://github.com/hasancse91/flutter_getx_template/blob/master/lib/app/core/base/paging_controller.dart) and
[PagingView](https://github.com/hasancse91/flutter_getx_template/blob/master/lib/app/core/widget/paging_view.dart):
view-owned scroll detection, model-owned loading/end-of-list state, append on
success, and refresh from the beginning. It does not introduce GetX.

1. The route creates `PostsViewModel` through get_it and calls `initialize()`.
2. `PagingView` owns/disposes its scroll controller and 500 ms timer. Forward
   scrolling beyond 75% of the scroll range asks the model for another page.
   A page too short to fill the viewport also requests more.
3. The model rejects duplicate triggers while loading or after the last page.
   `loadContent(LoadFeedTask)` publishes the existing ContentState contract.
4. The task calls the `PostsRepository` contract. Its data implementation maps
   results from `FeedRemoteDataSource`, which uses the shared ApiClient.
   DummyJSON uses `limit=10&skip=0`, then skip 10, 20, and so on.
5. The next offset advances by the number of server rows received. Posts are
   merged by ID, so duplicate records do not create duplicate cards. Reaching
   the server total or receiving an empty page ends pagination.
6. A failed append retains all loaded posts and offers an explicit retry of
   that same offset. Refresh waits for an in-flight page, then replaces the
   feed from offset zero. Failed refreshes retain the current feed. Search and
   tag filters start from zero and remain attached to subsequent pages.

The list uses lazy `ListView.builder` rendering. Append loading is a footer,
not the blocking workflow overlay. Core BaseViewModel, ContentViewModel,
BaseAction, task-chain, networking, and disposal contracts are unchanged.

### Files to follow

- `lib/core/widgets/paging_view.dart`: reusable scroll detection and pull-to-refresh.
- `lib/ui/posts/screens`: thin route screens for the feed and detail.
- `lib/ui/posts/widgets`: feed sections, post cards, actions, and comments.
- `lib/ui/posts/view_models/posts_view_model.dart`: pagination and retry decisions.
- `lib/domain/entities/feed.dart`: typed posts, comments, query, and page snapshot.
- `lib/domain/tasks/load_feed_task.dart`: pagination merging and the ordered
  post/comments detail workflow.
- `lib/domain/repositories/posts_repository.dart`: transport-independent posts contract.
- `lib/data/datasources/remote`: endpoint calls and response decoding.
- `lib/data/models`: Freezed DTOs with generated JSON serialization.
- `lib/data/mappers`: DTO-to-domain conversion.
- `lib/data/repositories/posts_repository_impl.dart`: model-to-entity repository implementation.
- `lib/routes/app_pages.dart`: route-owned Provider lifetimes; `/posts` and `/posts/:postId`.
- `lib/injection/injection.dart`: injected tasks, repositories, data sources,
  view models, and shared transport ownership.

`PostsRequest`, `PostsTask`, and `WritePost` retain the underlying documented
API operations for future workflows. The old endpoint-selector/JSON-explorer UI
has been replaced by the feed. DummyJSON simulates writes without persistence;
there is no automatic write retry or implication that those operations save data.

## Run and verify

```powershell
fvm flutter run
fvm flutter analyze
fvm flutter test
```

The default base URL is `https://dummyjson.com`; an internet connection is required.
Override with `--dart-define=API_BASE_URL=...` for a compatible backend.
`APP_ENV=production` validates HTTPS and positive timeouts at startup. Use the same
Flutter SDK for pub resolution, analysis, tests, and running the app. The
checked-in .fvmrc selects Flutter 3.47.1 (Dart 3.13.1); the global default
Flutter installation is older.

Tests use fake HTTP adapters and controlled futures, never a live service. They
cover offsets, duplicate IDs, short/empty/final pages, overlapping scroll requests,
retry, refresh, search/tags, disposal, detail navigation, themes, and localization.
Run `fvm flutter gen-l10n` after changing the English/Bengali ARB sources.

Agent guides: [.agents/AGENTS.md](.agents/AGENTS.md), [architecture](.agents/ARCHITECTURE.md),
[design](.agents/DESIGN_SYSTEM.md), [networking](.agents/NETWORKING.md), [localization](.agents/LOCALIZATION.md).

## Content loading

Use `ContentState<T>` for initial loading, content, empty results, refreshing,
and errors. Keep `ActionState` for write operations such as adding a post.
Data-driven models extend `ContentViewModel<T>`, implement
`isEmptyResult(T data)`, and call `loadContent(BaseTask<T>)`.
Refreshes and refresh failures retain previous data, including empty results.
Errors retain the original exception and stack trace; retries clear the error.
Feature screens render `contentState` and localize error feedback.
The `isFetching` flag is separate from the blocking workflow `isLoading` flag.
Content and workflow operations are independent. Overlapping content loads
reject with StateError. A new resource requires a fresh route-owned model.
Disposal clears data and suppresses notifications without cancelling accepted
work, whose future still returns its outcome. See
`test/content_view_model_test.dart` for these contracts.
