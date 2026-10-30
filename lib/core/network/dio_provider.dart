import 'dart:async';

import 'package:dio/dio.dart';

import 'api_config.dart';

typedef AccessTokenProvider = FutureOr<String?> Function();

/// Creates one client; get_it owns its lifetime. Interceptors are installed once.
Dio createDio(ApiConfig config, {AccessTokenProvider? accessTokenProvider}) {
  config.validate();
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl.endsWith('/')
          ? config.baseUrl
          : '${config.baseUrl}/',
      connectTimeout: config.connectTimeout,
      sendTimeout: config.sendTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    ),
  );
  if (accessTokenProvider != null) {
    dio.interceptors.add(_BearerTokenInterceptor(accessTokenProvider));
  }
  return dio;
}

class _BearerTokenInterceptor extends Interceptor {
  _BearerTokenInterceptor(this.readToken);
  final AccessTokenProvider readToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final base = Uri.parse(options.baseUrl);
      final target = options.uri;
      final sameOrigin =
          base.scheme == target.scheme &&
          base.host == target.host &&
          base.port == target.port;
      final hasAuthorization = options.headers.keys.any(
        (key) => key.toLowerCase() == 'authorization',
      );
      if (sameOrigin &&
          options.extra['requiresAuth'] != false &&
          !hasAuthorization) {
        final token = await readToken();
        if (token != null && token.trim().isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${token.trim()}';
        }
      }
      // Authenticated redirects must be handled explicitly by the caller.
      if (options.headers.keys.any(
        (key) => key.toLowerCase() == 'authorization',
      )) {
        options.followRedirects = false;
      }
      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
