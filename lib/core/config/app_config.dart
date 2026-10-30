import '../network/api_config.dart';

enum AppEnvironment { development, production }

/// Immutable application policy, supplied at the composition boundary.
/// Environment selection is independent of Flutter's debug/release mode.
class AppConfig {
  const AppConfig({
    this.environment = AppEnvironment.development,
    this.api = const ApiConfig(),
  });

  factory AppConfig.fromEnvironment({
    String environment = const String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    ),
    ApiConfig api = const ApiConfig(),
  }) => AppConfig(
    environment: switch (environment) {
      'development' => AppEnvironment.development,
      'production' => AppEnvironment.production,
      _ => throw ArgumentError('APP_ENV must be development or production.'),
    },
    api: api,
  );

  final AppEnvironment environment;
  final ApiConfig api;

  bool get isProduction => environment == AppEnvironment.production;

  /// Development validates API configuration when networking is first resolved.
  /// Production requires a configured HTTPS backend before registering services.
  void validate() {
    if (isProduction) api.validate(requireHttps: true);
  }
}
