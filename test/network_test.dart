import 'dart:typed_data';

import 'package:fleet_wise_user_app/core/base/base_remote_data_source.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/core/network/api_client.dart';
import 'package:fleet_wise_user_app/core/network/api_config.dart';
import 'package:fleet_wise_user_app/core/network/api_exception.dart';
import 'package:fleet_wise_user_app/core/network/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class FakeAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  int status = 200;
  String body = '{"value":42}';
  DioExceptionType? failure;
  bool closed = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (failure != null) {
      throw DioException(requestOptions: options, type: failure!);
    }
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {
    closed = true;
  }
}

class TestSource extends BaseRemoteDataSource {
  TestSource(super.apiClient);
  Future<int> value() => callApi(
    () => apiClient.request<dynamic>('value'),
    decode: (data) {
      if (data is! Map<String, dynamic> || data['value'] is! int) {
        throw const FormatException('Expected integer value');
      }
      return data['value'] as int;
    },
  );
}

void main() {
  late Dio dio;
  late FakeAdapter adapter;
  late ApiClient client;
  setUp(() {
    dio = createDio(const ApiConfig(baseUrl: 'https://example.test/v1'));
    adapter = FakeAdapter();
    dio.httpClientAdapter = adapter;
    client = ApiClient(dio);
  });
  tearDown(() => dio.close(force: true));

  test('configuration rejects missing URL and unbounded timeouts', () {
    expect(() => createDio(const ApiConfig(baseUrl: '')), throwsArgumentError);
    expect(
      () => createDio(
        const ApiConfig(
          baseUrl: 'https://example.test',
          connectTimeout: Duration.zero,
        ),
      ),
      throwsArgumentError,
    );
  });

  test(
    'request preserves method, query, body, options and decodes JSON',
    () async {
      final response = await client.request<Map<String, dynamic>>(
        'items',
        method: 'POST',
        data: {'name': 'example'},
        queryParameters: {'page': 2},
        options: Options(headers: {'X-Test': 'yes'}),
      );
      expect(response.data, {'value': 42});
      final request = adapter.requests.single;
      expect(request.uri.toString(), 'https://example.test/v1/items?page=2');
      expect(request.method, 'POST');
      expect(request.data, {'name': 'example'});
      expect(request.headers['X-Test'], 'yes');
      expect(request.connectTimeout, const Duration(seconds: 30));
    },
  );

  test(
    'accepts list responses and 201/204 without requiring a JSON envelope',
    () async {
      adapter.status = 201;
      adapter.body = '[1,2]';
      expect(
        (await client.request<List<dynamic>>('items', method: 'POST')).data,
        [1, 2],
      );
      adapter.status = 204;
      adapter.body = '';
      expect(
        (await client.request<dynamic>('items', method: 'DELETE')).statusCode,
        204,
      );
    },
  );

  for (final entry in {
    401: ApiErrorKind.unauthorized,
    403: ApiErrorKind.forbidden,
    404: ApiErrorKind.notFound,
    429: ApiErrorKind.rateLimited,
    503: ApiErrorKind.server,
  }.entries) {
    test('maps HTTP ${entry.key} without retrying a write', () async {
      adapter.status = entry.key;
      adapter.body = '"unstructured server response"';
      await expectLater(
        client.request<dynamic>('items', method: 'POST'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kind, 'kind', entry.value)
              .having((e) => e.statusCode, 'status', entry.key)
              .having((e) => e.cause, 'cause', isA<DioException>()),
        ),
      );
      expect(adapter.requests, hasLength(1));
    });
  }

  test('maps transport failure and cancellation', () async {
    adapter.failure = DioExceptionType.connectionTimeout;
    await expectLater(
      client.request<dynamic>('items'),
      throwsA(
        isA<ApiException>().having((e) => e.kind, 'kind', ApiErrorKind.timeout),
      ),
    );
    final cancel = CancelToken()..cancel();
    await expectLater(
      client.request<dynamic>('items', cancelToken: cancel),
      throwsA(
        isA<ApiException>().having(
          (e) => e.kind,
          'kind',
          ApiErrorKind.cancelled,
        ),
      ),
    );
    expect(adapter.requests, hasLength(1));
  });

  test('token is fresh, optional and limited to API origin', () async {
    var token = 'one';
    final authDio = createDio(
      const ApiConfig(baseUrl: 'https://example.test'),
      accessTokenProvider: () => token,
    );
    addTearDown(() => authDio.close(force: true));
    authDio.httpClientAdapter = adapter;
    final authClient = ApiClient(authDio);
    await authClient.request<dynamic>('a');
    token = 'two';
    await authClient.request<dynamic>('b');
    await authClient.request<dynamic>(
      'public',
      options: Options(extra: {'requiresAuth': false}),
    );
    await authClient.request<dynamic>('https://other.test/a');
    expect(adapter.requests[0].headers['Authorization'], 'Bearer one');
    expect(adapter.requests[1].headers['Authorization'], 'Bearer two');
    expect(adapter.requests[0].followRedirects, isFalse);
    expect(adapter.requests[2].headers['Authorization'], isNull);
    expect(adapter.requests[3].headers['Authorization'], isNull);
  });

  test('token lookup failures complete as typed errors', () async {
    final authDio = createDio(
      const ApiConfig(baseUrl: 'https://example.test'),
      accessTokenProvider: () => throw StateError('storage unavailable'),
    );
    addTearDown(() => authDio.close(force: true));
    authDio.httpClientAdapter = adapter;
    await expectLater(
      ApiClient(authDio).request<dynamic>('a'),
      throwsA(isA<ApiException>()),
    );
    expect(adapter.requests, isEmpty);
  });

  test('remote source validates response shape', () async {
    final source = TestSource(client);
    expect(await source.value(), 42);
    adapter.body = '[]';
    await expectLater(
      source.value(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.kind,
          'kind',
          ApiErrorKind.invalidData,
        ),
      ),
    );
  });

  test('DI shares the client and closes its adapter on reset', () async {
    final container = GetIt.asNewInstance();
    configureDependencies(
      container,
      apiConfig: const ApiConfig(baseUrl: 'https://example.test'),
    );
    addTearDown(() => container.reset());
    final registered = container<Dio>();
    registered.httpClientAdapter = adapter;
    expect(container<ApiClient>(), same(container<ApiClient>()));
    await container<ApiClient>().request<dynamic>('a');
    await container.reset();
    expect(adapter.closed, isTrue);
  });
}
