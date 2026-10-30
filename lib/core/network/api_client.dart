import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Shared transport boundary. Feature code owns endpoints and model decoding.
class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  Future<Response<T>> request<T>(
    String path, {
    String method = 'GET',
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(ApiException.fromDio(error), stackTrace);
    }
  }
}
