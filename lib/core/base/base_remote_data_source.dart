import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../network/api_exception.dart';

/// Shared base for remote data sources, supplied through constructor DI.
abstract class BaseRemoteDataSource {
  const BaseRemoteDataSource(this.apiClient);

  final ApiClient apiClient;

  Future<T> callApi<T>(
    Future<Response<dynamic>> Function() request, {
    required T Function(dynamic data) decode,
  }) async {
    final response = await request();
    try {
      return decode(response.data);
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ApiException(
          ApiErrorKind.invalidData,
          'The server returned invalid data.',
          statusCode: response.statusCode,
          cause: error,
        ),
        stackTrace,
      );
    }
  }
}
