# Architecture instructions for agents

## User migration override

This Flutter architecture governs every converted module. Java Activities, MVP presenters, and repository wiring are behavior evidence, not Dart structure. Keep Provider MVVM, get_it, go_router, and the `ui -> domain <- data` direction.
Actions are domain workflows: create them only in `lib/domain/actions`, never under `lib/ui`. Name them `<Feature><Purpose>Action` without a `Run` or `run_` prefix. Inject concrete domain tasks, orchestrate them with `TaskChain` and `runTask`, and use a typed task factory only when a later task needs an earlier result. Put every feature task in `lib/domain/tasks/<feature>`; shared cross-feature abstractions belong in `lib/core`, not a flat task directory.
Pinned Java endpoint contracts and JSON decoding stay in `data`; the DummyJSON posts feature does not define a migrated User module's contract.

Read this guide before changing application code or tests. Preserve the existing
Flutter MVVM architecture: Provider observes and owns view models, get_it composes
dependencies, and go_router owns route configuration. Inspect the nearest feature
and its tests before extending it. Explicit user requirements take precedence;
keep routine implementation choices within the requested scope.

Source paths below are relative to the repository root. Guide links are relative
to `.agents`. Read [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) for UI changes,
[NETWORKING.md](NETWORKING.md) for HTTP integrations, and
[LOCALIZATION.md](LOCALIZATION.md) for user-facing text changes.

## Layer structure and responsibilities

This repository uses a layer-first Clean Architecture layout. Follow this
structure for every feature; do not reintroduce `lib/features` or combine
responsibilities in a convenient single file:

| Directory | Responsibility |
| --- | --- |
| `lib/ui/<feature>/screens` | Own route-level BaseView composition, navigation, and user intent. |
| `lib/ui/<feature>/widgets` | Hold focused feature UI sections used by screens or other feature widgets. |
| `lib/ui/<feature>/view_models` | Own observable presentation state and start injected actions/tasks. |
| `lib/domain/actions` | Coordinate business workflows through injected tasks, without UI dependencies. |
| `lib/domain/entities` | Transport- and framework-independent business data. |
| `lib/domain/repositories` | Abstract contracts consumed by domain tasks. |
| `lib/domain/tasks/<feature>` | Implement individual application operations against repository contracts. |
| `lib/data/models` | Freezed API/storage DTOs with json_serializable factories. |
| `lib/data/mappers` | Convert data models to domain entities. |
| `lib/data/datasources/remote` | Own endpoint calls, response validation, and decoding to data models. |
| `lib/data/repositories` | Implement domain repository contracts using data sources and mappers. |
| `lib/injection` | Compose all concrete dependencies at the application boundary. |
| `lib/core` | Reusable infrastructure with no feature-specific behavior. |

The dependency direction is `ui -> domain <- data`; only `lib/injection`
knows all layers. Domain code must never import from `data` or `ui`. UI code
must not import concrete data sources, data models, mappers, or repository
implementations. Data may depend on domain contracts and entities, but not UI.

Keep route-level screen classes in screens and extract cohesive visual sections
into named widgets under the feature widgets folder. Screens keep route ownership
and navigation; widgets receive data and callbacks or the route-owned view model
without creating providers, routers, or shared clients. Cross-feature components
belong in lib/core/widgets.

Keep one public responsibility per file. In particular, never declare a remote
data source in a domain task file. Each concrete remote source belongs in its own
`lib/data/datasources/remote/*_remote_data_source.dart` file and extends
`BaseRemoteDataSource`. Each repository implementation belongs in
`lib/data/repositories`; tasks receive the corresponding interface from
`lib/domain/repositories`.

All data-layer DTOs use `@freezed` and generated `fromJson`/`toJson`
factories. Keep both `.freezed.dart` and `.g.dart` part declarations beside
the source model and regenerate with `dart run build_runner build` after model
changes.
Do not hand-write equality, copyWith, or JSON field extraction in data models.
Domain entities remain plain transport-independent Dart objects unless an
explicit domain requirement justifies generated value semantics.

Feature screens override BaseView.operationLabel for localized task labels;
BaseView.errorMessage delegates network failures to the shared presentation
mapper. Keep navigation, BuildContext, and translated display strings out of
actions, tasks, repositories, data sources, and injection. View models must not
depend on navigation or BuildContext; format localized feedback in presentation
code.

Posts integrations call DummyJSON. Its write endpoints simulate changes without
persistence. Endpoint contracts and JSON decoding stay in `data`; domain tasks
remain transport-independent.

## Navigation ownership

Define routes and route-level providers in `lib/routes/app_pages.dart`.
`lib/routes/app_routes.dart` is a part of that library: Routes exposes public
constants and _Paths contains private path definitions. Follow the existing
named-route and pathParameters convention.

`PostsApp` in `lib/main.dart` creates and disposes one router for its lifetime.
Keep one root MaterialApp; do not create routers or app roots inside features.
Navigate from presentation code. Use goNamed to navigate to a destination and
pushNamed when the previous page should remain on the navigation stack.

The route's ChangeNotifierProvider creates and disposes its view model. When a
route parameter identifies a different resource, use provider identity/keying
that creates fresh state for that resource, when adding a resource-specific route.
BaseView observes the ancestor provider; it does not create or dispose the model.
Preserve platform deep links and unknown-route recovery when changing routing.

## Dependency injection

Register the dependency graph in `lib/injection/injection.dart`. `main()` calls
configureDependencies before building the app. Keep locator resolution at the
composition boundary: DI registrations and route-level provider creation.
Do not import or resolve get_it in view models, actions, tasks, or remote sources.

Inject dependencies through constructors. Inject typed factories when an action
or task needs runtime inputs or results from a preceding step. Constructors and
factories should construct objects without starting work; the view model's busy
guard runs when execute is called, after its action argument has been created.

Register view models and mutable actions as factories, not shared singletons.
Create a fresh action for each user operation or retry. Existing action defaults
support standalone use, but application registrations explicitly compose their
dependencies. The container owns the lazy shared Dio/ApiClient pair and closes
Dio on reset. Screens must not close shared clients.

Platform plugins are exposed through injected interfaces in `lib/core/utils/platform`
and `lib/core/storage`. Resolve `AppPackageInfo`, `AppImagePicker`, and
`AppPreferences` only at composition boundaries or inject them into feature
tasks/services. Keep plugin types out of view models. Preferences are for
non-sensitive settings only; authentication secrets require secure storage.
Image-picking features must handle cancellation and call `recoverLostImages`
where Android activity destruction can interrupt a picker result.

## App configuration

AppConfig in `lib/core/config/app_config.dart` owns the selected environment and
ApiConfig. configureDependencies reads APP_ENV/API_BASE_URL by default or accepts
an injected AppConfig. Keep configuration immutable and inject it into consumers;
do not introduce a global mutable configuration singleton. Development retains
lazy network validation; production validates a required HTTPS base URL and
positive timeouts before service registration. APP_ENV is independent of build
mode and defaults to development. See README launch commands. Add native flavors
only when separate native app identities are needed. Cover changes with
`test/app_config_test.dart` and the DI/network tests.

## Task and action contracts

- `BaseTask<T>` exposes a diagnostic name and `Future<T>` run(). A concrete task owns
  its operation; pass input data and dependencies rather than a generic job callback.
- BaseAction.run() returns `Future<void>`. Execute each task through runTask so a
  failure records the task name and rethrows the original error with its stack.
  Do not swallow a failure and continue the remaining workflow.
- TaskChain.start().add().execute() is lazy. Each step receives the preceding
  result; use typed models or records to retain multiple results. execute returns
  the final result, stops on failure, and starts the pipeline afresh on each call.
  Do not add mutable task links or shared stored results to implement chaining.
- Retrying a posts write requires a new explicit user operation. Do not
  automatically replay real writes without an explicit idempotency contract.

BaseViewModel.execute accepts one action at a time. It publishes running state,
then returns a succeeded or failed ActionState. Accepted action failures preserve
the original error, stackTrace, and failedTask in that outcome. Busy or disposed
models reject new execution with StateError instead of a failed ActionState.
Starting a new accepted execution clears the previous error. resetState returns
false during execution or after disposal; otherwise it resets state to idle.
Preserve these distinctions when adding view-model methods or error handling.

## Disposal and asynchronous work

Provider owns route view-model disposal; the root app owns router disposal; the
DI container owns shared-client disposal. An object that creates a timer, stream
subscription, or controller must give it an explicit cleanup owner. Borrowed
resources remain the responsibility of their owner.

Disposing BaseViewModel stops further UI notifications and clears its state but
does not cancel already accepted work. Its pending execute future still returns
the final outcome. Preserve this tested behavior unless cancellation is explicitly
part of the requested change. A CancelToken belongs to its caller; disposing a
screen must not implicitly close the shared transport. Continuing in-process work
does not provide persistence across app termination or a background-job system.

For new asynchronous presentation flows, prevent stale results from updating a
disposed model or a different resource. If adding cancellation, define who
cancels, how it is represented, and which side effects can already have occurred;
update the execution contracts, tests, and guides together.

## Testing and verification

Run commands from the repository root. For Dart changes, format affected files,
run `flutter analyze`, and run tests covering the changed behavior. Run the full
`flutter test` suite after changes to shared bases, DI, routing, or execution
contracts. Documentation-only edits need link/path and consistency checks rather
than a Flutter test run. Report checks that could not run and why; do not claim
unperformed verification.

Use the existing tests as contract references:

| Change area | Relevant tests under `test/` |
| --- | --- |
| Task results and workflow ordering/failures | `posts_test.dart`, `task_chain_test.dart` |
| Busy guard, retry, disposal, and notifications | `execution_contract_test.dart`, `view_model_lifecycle_test.dart` |
| Dependency lifetime and construction | `dependency_injection_test.dart` |
| Route ownership and deep links | `app_router_test.dart` |
| Shared shell and layouts | `base_view_test.dart`, `app_theme_test.dart`, `design_system_test.dart` |
| HTTP behavior and decoding | `network_test.dart` |
| Translation parity and locale behavior | `localization_test.dart` |

Use injected fakes and controlled futures for ordering, failures, overlapping
execution, and disposal; see `test/support/test_actions.dart`. Test observable
contracts rather than duplicating implementation details. Network tests must use
fake adapters, not a live backend. Use GetIt.asNewInstance for isolated DI tests
and await reset in teardown; explicitly dispose factory-created view models.
App widget tests must configure the global container because they do not call
main, and must reset it afterward. Localized widget wrappers need localization
delegates and supportedLocales. Follow the UI/localization guides for appearance,
text scaling, and language checks.

Update this guide alongside intentional changes to shared architecture contracts.

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

## Feed pagination

`PostsViewModel` extends ContentViewModel<FeedPage>. LoadFeedTask receives an
immutable prior page for append, or null for replacement; it owns fetching and
deduplicating posts. FeedPage stores the server offset/total and query. Advance
offsets using received row count, not unique rendered count. Empty pages end
pagination. Failed pages retain data and offset for explicit retry.

The reusable PagingView owns its scroll controller and debounce timer and uses
a lazy list. It forwards load/refresh intent; it never calls APIs or resolves DI.
The model holds the loading guard until completion. Refresh waits for accepted
work before reloading page zero. Provider owns models; resource detail routes
key their provider by postId. Test these contracts in posts_test.dart and
feed_view_test.dart. Shared content/action/disposal contracts remain unchanged.
