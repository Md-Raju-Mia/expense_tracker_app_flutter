import 'package:fleet_wise_user_app/core/config/app_config.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/core/network/api_client.dart';
import 'package:fleet_wise_user_app/core/network/api_config.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  late GetIt container;
  setUp(() => container = GetIt.asNewInstance());
  tearDown(() => container.reset());

  test(
    'environment parsing rejects typos rather than selecting development',
    () {
      expect(
        AppConfig.fromEnvironment(environment: 'development').isProduction,
        isFalse,
      );
      expect(
        AppConfig.fromEnvironment(environment: 'production').isProduction,
        isTrue,
      );
      expect(
        () => AppConfig.fromEnvironment(environment: 'prod'),
        throwsArgumentError,
      );
      expect(
        () => AppConfig.fromEnvironment(environment: ''),
        throwsArgumentError,
      );
    },
  );

  test('development constructs models without resolving networking', () {
    configureDependencies(
      container,
      appConfig: const AppConfig(api: ApiConfig(baseUrl: '')),
    );
    final model = container<PostsViewModel>();
    model.dispose();
    expect(() => container<ApiClient>(), throwsArgumentError);
  });

  test('injected production configuration supplies the exact API instance', () {
    const api = ApiConfig(
      baseUrl: 'https://example.test/v1',
      receiveTimeout: Duration(seconds: 9),
    );
    const config = AppConfig(environment: AppEnvironment.production, api: api);
    configureDependencies(container, appConfig: config);
    expect(container<AppConfig>(), same(config));
    expect(container<ApiConfig>(), same(api));
    expect(container<Dio>().options.baseUrl, 'https://example.test/v1/');
    expect(container<Dio>().options.receiveTimeout, const Duration(seconds: 9));
  });

  for (final api in [
    const ApiConfig(baseUrl: ''),
    const ApiConfig(baseUrl: 'http://example.test'),
    const ApiConfig(
      baseUrl: 'https://example.test',
      connectTimeout: Duration.zero,
    ),
  ]) {
    test(
      'invalid production config fails before registrations: ${api.baseUrl} / ${api.connectTimeout}',
      () {
        expect(
          () => configureDependencies(
            container,
            appConfig: AppConfig(
              environment: AppEnvironment.production,
              api: api,
            ),
          ),
          throwsArgumentError,
        );
        expect(container.isRegistered<AppConfig>(), isFalse);
        expect(container.isRegistered<ApiConfig>(), isFalse);
        expect(container.isRegistered<Dio>(), isFalse);
      },
    );
  }

  test('existing API injection remains supported for local development', () {
    const api = ApiConfig(baseUrl: 'http://localhost:8080');
    configureDependencies(container, apiConfig: api);
    expect(container<AppConfig>().api, same(api));
    expect(container<Dio>().options.baseUrl, 'http://localhost:8080/');
  });

  test('ambiguous app and API overrides fail before registration', () {
    expect(
      () => configureDependencies(
        container,
        appConfig: const AppConfig(),
        apiConfig: const ApiConfig(),
      ),
      throwsArgumentError,
    );
    expect(container.isRegistered<AppConfig>(), isFalse);
  });
}
