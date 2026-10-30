import 'package:dio/dio.dart';

enum ApiErrorKind {
  timeout,
  connection,
  cancelled,
  certificate,
  unauthorized,
  forbidden,
  notFound,
  rateLimited,
  server,
  response,
  invalidData,
  unknown,
}

/// Stable classification for callers, with the original error for diagnostics.
/// Server response bodies are not used as user-visible error messages.
class ApiException implements Exception {
  const ApiException(this.kind, this.message, {this.statusCode, this.cause});

  final ApiErrorKind kind;
  final String message;
  final int? statusCode;
  final Object? cause;

  factory ApiException.fromDio(DioException error) {
    final status = error.response?.statusCode;
    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => ApiErrorKind.timeout,
      DioExceptionType.connectionError => ApiErrorKind.connection,
      DioExceptionType.cancel => ApiErrorKind.cancelled,
      DioExceptionType.badCertificate => ApiErrorKind.certificate,
      DioExceptionType.badResponse => switch (status ?? 0) {
        401 => ApiErrorKind.unauthorized,
        403 => ApiErrorKind.forbidden,
        404 => ApiErrorKind.notFound,
        429 => ApiErrorKind.rateLimited,
        >= 500 => ApiErrorKind.server,
        _ => ApiErrorKind.response,
      },
      _ =>
        error.error is FormatException
            ? ApiErrorKind.invalidData
            : ApiErrorKind.unknown,
    };
    return ApiException(
      kind,
      switch (kind) {
        ApiErrorKind.timeout => 'The request timed out.',
        ApiErrorKind.connection => 'Could not connect to the server.',
        ApiErrorKind.cancelled => 'The request was cancelled.',
        ApiErrorKind.certificate =>
          'The server certificate could not be verified.',
        ApiErrorKind.unauthorized => 'Authentication is required.',
        ApiErrorKind.forbidden => 'This request is not permitted.',
        ApiErrorKind.notFound => 'The requested resource was not found.',
        ApiErrorKind.rateLimited =>
          'Too many requests. Please try again later.',
        ApiErrorKind.server => 'The server could not complete the request.',
        ApiErrorKind.response => 'The request was rejected.',
        ApiErrorKind.invalidData => 'The server returned invalid data.',
        ApiErrorKind.unknown => 'The request could not be completed.',
      },
      statusCode: status,
      cause: error,
    );
  }

  @override
  String toString() =>
      'ApiException(${kind.name}, status: $statusCode): $message';
}
