import '../../l10n/l10n.dart';
import '../network/api_exception.dart';

/// Presentation-only mapping. Diagnostic messages and server payloads never
/// become display text. The caller supplies an already localized operation.
String localizedErrorMessage(
  AppLocalizations strings,
  Object failure, {
  required String operation,
}) {
  if (failure is! ApiException) return strings.operationFailed(operation);
  return switch (failure.kind) {
    ApiErrorKind.timeout => strings.networkTimeout,
    ApiErrorKind.connection => strings.networkConnection,
    ApiErrorKind.cancelled => strings.networkCancelled,
    ApiErrorKind.certificate => strings.networkCertificate,
    ApiErrorKind.unauthorized => strings.networkUnauthorized,
    ApiErrorKind.forbidden => strings.networkForbidden,
    ApiErrorKind.notFound => strings.networkNotFound,
    ApiErrorKind.rateLimited => strings.networkRateLimited,
    ApiErrorKind.server => strings.networkServer,
    ApiErrorKind.response => strings.networkResponse,
    ApiErrorKind.invalidData => strings.networkInvalidData,
    ApiErrorKind.unknown => strings.operationFailed(operation),
  };
}
