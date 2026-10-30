# Networking guide for agents

## User migration override

For converted iFleet User operations, preserve the Java app's observable request, response, error, timeout, and retry behavior exactly. Do not add validation, retries, deduplication, or different error presentation because the template would normally prefer them. Use the pinned Java module contract in its dedicated remote data source; never derive a migrated endpoint contract from the DummyJSON sample or invent missing backend behavior.

Use the shared Dio networking layer for new HTTP operations. Concrete endpoint
calls belong in `lib/data/datasources/remote`; domain tasks depend on interfaces
from `lib/domain/repositories`, never on ApiClient or a concrete data source.
Never construct Dio or resolve get_it inside tasks, actions, view models,
repositories, or data sources. Register dependencies in
`lib/injection/injection.dart` and inject them through constructors.

## Configuration and ownership

`ApiConfig` holds base URL and positive connect/send/receive timeouts (30 seconds
by default). The default base URL is https://dummyjson.com. Override it with `--dart-define=API_BASE_URL=...`
or inject AppConfig with its ApiConfig into configureDependencies. The legacy apiConfig argument remains supported; do not pass both overrides. APP_ENV selects development (default) or production independently of Flutter build mode. Production validates a required HTTPS URL and timeouts before registration. Use HTTPS for deployed APIs.
Relative endpoint paths should omit a leading slash. The base URL is normalized
to a trailing slash so an API path prefix is retained.

The container owns one lazy Dio and ApiClient. Posts requests use the configured base URL. Development validates the URL when networking is first resolved; production validates HTTPS at startup. Resetting the container closes Dio. Screens must not close the shared client. Android includes INTERNET permission. Platform transport policy and browser CORS still apply.

## Request and response pattern

ApiClient.request supports method, data (including FormData), query parameters,
Dio Options, cancellation, and upload/download progress callbacks. It returns
Response<T>, preserves Dio's default successful 2xx handling, and imposes no
backend-specific JSON envelope. Example inside an injected task or remote source:

```dart
final response = await apiClient.request<Map<String, dynamic>>(
  'items',
  method: 'POST',
  data: payload,
  cancelToken: cancelToken,
);
```

Use the documented DummyJSON posts contracts in `lib/data/datasources/remote`.
Reads fetch remote data. POST, PATCH, and DELETE return simulated changes without
persisting them. Do not invent other endpoint contracts.

Each remote data source lives in its own `*_remote_data_source.dart` file,
extends `BaseRemoteDataSource(apiClient)`, and uses callApi with a request
closure and decode function. It decodes responses to models from
`lib/data/models`; mapping those models to domain entities belongs in
`lib/data/mappers` and repository implementations. Validate JSON shape
explicitly and throw FormatException for malformed payloads; callApi maps it to
invalidData. Unexpected programming errors are not relabeled as network failures.
Use dynamic response data with explicit decoding when validation needs to inspect
its shape.

Data models use Freezed and json_serializable. Parse untyped response values
through the shared data-model decoder so generated checked-conversion failures
become FormatException before reaching BaseRemoteDataSource. Regenerate committed
part files after every DTO change.

ApiException exposes kind, statusCode, a stable message, and original cause.
The client preserves the caught stack trace. Error response bodies are not
assumed to be maps or exposed as display text. Existing BaseAction/BaseViewModel
already preserve exceptions and failed-task diagnostics. The presentation mapper localizes ApiErrorKind without displaying diagnostic messages or response bodies; unknown errors use localized operation feedback.
Cancellation is classified separately; callers own CancelToken and decide when
to cancel. View-model disposal still does not automatically cancel accepted work.

## Authentication and retries

Pass accessTokenProvider to configureDependencies to read a token from the app's
chosen session/secure storage. It is invoked per request; no token is stored in
this layer. `Options(extra: {'requiresAuth': false})` skips automatic injection.
An explicit Authorization header wins. Automatically supplied tokens are limited
to the configured origin; authenticated redirects are disabled by the interceptor.
Do not send explicit credentials to unrelated endpoints.

No authentication server contract was supplied, so refresh/login/storage are not
implemented. No request or response bodies, headers, or credentials are logged.
No automatic retry is installed: do not replay writes without the backend's
idempotency contract. A future refresh/retry feature must preserve request options,
cancellation, and payload replayability and have bounded retry tests.

## Verification

Run `flutter test test/network_test.dart` for fake-adapter tests, then the full
suite for integration changes. Tests do not call a live backend. Cover status
codes, response shapes, auth changes, cancellation, and disposal when extending
this layer. Keep this guide updated alongside shared networking changes.

Reference architecture:
https://github.com/hasancse91/flutter_getx_template/tree/f1ebf2f/lib/app/network
Dio documentation: https://pub.dev/packages/dio
