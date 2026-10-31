# Expense Tracker

An offline Flutter expense tracker using Provider MVVM, get_it, go_router, and SQLite.

## Expense app

The default route is /expenses. Use Settings in the Home app bar to select country, currency and language, and save your choices. Fresh preferences default to Bangladesh, BDT and Bengali. Bangladesh, India and the United States are currently available; currency and language can be overridden independently.

Each transaction retains its own currency code. Home totals and the spending chart use the selected currency; recent transactions include all currencies with their original amounts. Existing dollar-denominated data upgrades as USD without conversion. New transactions use the saved preferred currency. Settings survive restart; leaving settings without saving discards the draft.

New transactions require a nonblank title and a positive amount with up to two decimal places. Amount input accepts English or Bengali digits without grouping commas. Amounts use integer minor units throughout input, domain and SQLite storage (1250 means 12.50). Report totals use BigInt and display exact cents in English/Bengali; only chart drawing proportions use doubles.

Database v4 adds amountMinor. Upgrading v1/v2/v3 preserves the original amount column, IDs, sync IDs, dates and currencies. Legacy amounts round to the nearest minor unit, with ties away from zero (12.345 becomes 1235, -12.345 becomes -1235); zero and negative legacy rows remain in totals. Rounding each old row can change totals for records with more than two decimals. New rows use amountMinor and leave the old REAL amount column empty. If an old value is nonnumeric, nonfinite or outside the SQLite INTEGER range, the upgrade rolls back rather than dropping or clamping data; that record needs repair before opening the database again.

The UI uses a high-contrast teal balance card, an Add Transaction action below the scrollable content, and layouts that wrap for large text. The expense journey currently uses a light theme.

Database v5 adds a separate categories table with seven stable built-in IDs, name/icon/color metadata and archive state. The category repository supports create, edit, archive and restore; active names are unique within income/expense type. Editing retains identity and type. This storage foundation is not yet connected to a management screen or the transaction picker; existing transactions still use their original category indices.

## Posts sample (/posts)

Open /posts to load the first ten sample posts automatically. Scroll to discover more,
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

### Canonical feature placement

Presentation belongs in `lib/ui/<feature>/{screens,widgets,view_models}`. Workflow actions belong in `lib/domain/actions`, named `<Feature><Purpose>Action`. Individual tasks belong in `lib/domain/tasks/<feature>`. Actions coordinate injected tasks through `TaskChain` and `runTask`; navigation remains in presentation. These rules also apply to sample code. See [.agents/ARCHITECTURE.md](.agents/ARCHITECTURE.md).

### Files to follow

- `lib/core/widgets/paging_view.dart`: reusable scroll detection and pull-to-refresh.
- `lib/ui/posts/screens`: thin route screens for the feed and detail.
- `lib/ui/posts/widgets`: feed sections, post cards, actions, and comments.
- `lib/ui/posts/view_models/posts_view_model.dart`: pagination and retry decisions.
- `lib/domain/entities/feed.dart`: typed posts, comments, query, and page snapshot.
- `lib/domain/tasks/posts/load_feed_task.dart`: pagination merging and the ordered
  post/comments detail workflow.
- `lib/domain/repositories/posts_repository.dart`: transport-independent posts contract.
- `lib/data/datasources/remote`: endpoint calls and response decoding.
- `lib/data/models`: Freezed DTOs with generated JSON serialization.
- `lib/data/mappers`: DTO-to-domain conversion.
- `lib/data/repositories/posts_repository_impl.dart`: model-to-entity repository implementation.
- `lib/routes/app_pages.dart`: route-owned Provider lifetimes; `/posts` and `/posts/:postId`.
- `lib/injection/injection.dart`: injected tasks, repositories, data sources,
  view models, and shared transport ownership.

`PostsRequest`, `PostsTask`, and `PostsWriteAction` retain the underlying documented
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
