# Expense Tracker

An offline Flutter expense tracker using Provider MVVM, get_it, go_router, and SQLite.

## Expense app

The default route is /expenses. Use Settings in the Home app bar to select country, currency and language, and save your choices. Fresh preferences default to Bangladesh, BDT and Bengali. Bangladesh, India and the United States are currently available; currency and language can be overridden independently.

Each transaction retains its own currency code. Home totals and the spending chart use the selected currency; recent transactions include all currencies with their original amounts. Existing dollar-denominated data upgrades as USD without conversion. New transactions use the saved preferred currency. Settings survive restart; leaving settings without saving discards the draft.

New transactions require a nonblank title and a positive amount with up to two decimal places. Amount input accepts English or Bengali digits without grouping commas. Amounts use integer minor units throughout input, domain and SQLite storage (1250 means 12.50). Report totals use BigInt and display exact cents in English/Bengali; only chart drawing proportions use doubles.

Use the pencil beside a transaction to edit its title, amount, date, type or category. The shared add/edit form retains the original currency, local ID and sync ID; updating never creates another transaction. An archived original category may be retained, while a replacement must be active and match the chosen type. Back discards changes, failed saves retain inputs, and saving a deleted transaction reports that it no longer exists. Successful edits refresh Home totals and charts.

Open Transaction history from the Home history icon or See all. Filter all transactions by a calendar day, month or year; rows remain newest first, retain their own currency and include archived categories. Year choices include recorded years and the current year. Editing from history reloads the rows while keeping the selected period. Refresh failures retain the previous results and offer retry. Date filtering uses each transaction’s stored calendar date; history does not combine different currencies into a total.


Database v4 adds amountMinor. Upgrading v1/v2/v3 preserves the original amount column, IDs, sync IDs, dates and currencies. Legacy amounts round to the nearest minor unit, with ties away from zero (12.345 becomes 1235, -12.345 becomes -1235); zero and negative legacy rows remain in totals. Rounding each old row can change totals for records with more than two decimals. New rows use amountMinor and leave the old REAL amount column empty. If an old value is nonnumeric, nonfinite or outside the SQLite INTEGER range, the upgrade rolls back rather than dropping or clamping data; that record needs repair before opening the database again.

The UI uses a high-contrast teal balance card, an Add Transaction action below the scrollable content, and layouts that wrap for large text. The expense journey currently uses a light theme.

Use the category icon in the Home app bar to manage categories. Filter income/expense and active/archived categories, add a category, edit its name/icon/color, or archive and restore it. Archive requires confirmation. Failed saves keep the draft for retry; leaving the screen discards unsaved edits. Built-in names follow the saved language until renamed. Names allow 1–60 user-perceived characters, including Bengali combined letters.

Database v5 introduced the categories table; v6 links transactions through stable categoryId references. Existing category indices and every original transaction field remain intact for recovery. Upgrades preserve renamed/archived defaults and custom categories, local IDs, sync IDs and amounts. Invalid legacy references roll back the upgrade. Foreign keys and null-reference guards prevent orphaned transactions.

Both expense and income forms load active categories from storage. Manage categories can be opened from the form without losing its title, amount or date. Switching transaction type remembers each type's selection. If a selected category is archived while the draft is open, choose another explicitly; no other category is silently substituted. With no active categories, Save is disabled and management remains available. Writes validate category existence, active state and type in the same database transaction as insertion. A failed save keeps the form and inputs for retry.

History and charts load current category names/icons/colors, including archived categories. Renaming/restyling a category updates its presentation on past transactions without changing their amounts, type or category identity. Totals group by stable ID, not name; reusing an archived name does not merge distinct categories. Identical translated default/custom names are labeled distinctly, and archived history is marked. Active stored names remain unique within income/expense type; the form also rejects duplicate translated display names. Category names wrap for enlarged text. Income/expense type stays immutable after creation.

## Android ads

Transaction History can show an anchored adaptive AdMob banner when it contains
transactions. The banner is separated from the scrollable content and disappears
when unavailable. Saving and sharing PDFs are available independently of ads.

Ads are off by default. To test with Google's demo app and banner unit, run
`flutter run --dart-define=ADMOB_TEST_ADS=true`. This flag only enables test ads
in debug or profile builds.

For a production Android build, configure the app, History banner unit, and
applicable privacy messages in AdMob. Pass the app and banner IDs from the same
publisher to the release build:

```powershell
flutter build appbundle --release --dart-define=ADMOB_ANDROID_APP_ID=YOUR_APP_ID --dart-define=ADMOB_ANDROID_HISTORY_BANNER_ID=YOUR_BANNER_ID
```

Google's UMP SDK controls ad eligibility and whether the ad privacy entry appears
in Settings. Requests contain no transaction or PDF data.

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
