/// API_BASE_URL is supplied with --dart-define when using a real backend.
class ApiConfig {
  const ApiConfig({
    this.baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://dummyjson.com',
    ),
    this.connectTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  final String baseUrl;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;

  void validate({bool requireHttps = false}) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw ArgumentError(
        'API_BASE_URL must be an absolute HTTP(S) base URL without credentials, query, or fragment.',
      );
    }
    if (requireHttps && uri.scheme != 'https') {
      throw ArgumentError('Production API_BASE_URL must use HTTPS.');
    }
    for (final timeout in [connectTimeout, sendTimeout, receiveTimeout]) {
      if (timeout <= Duration.zero) {
        throw ArgumentError('API timeouts must be positive.');
      }
    }
  }
}
