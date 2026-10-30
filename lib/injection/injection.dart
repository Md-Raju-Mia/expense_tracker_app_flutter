import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/api_config.dart';
import '../core/network/dio_provider.dart';
import '../core/storage/app_preferences.dart';
import '../core/utils/platform/app_image_picker.dart';
import '../core/utils/platform/app_package_info.dart';
import '../data/datasources/remote/feed_remote_data_source.dart';
import '../data/datasources/remote/posts_remote_data_source.dart';
import '../data/repositories/posts_repository_impl.dart';
import '../domain/entities/feed.dart';
import '../domain/entities/posts_request.dart';
import '../domain/repositories/posts_repository.dart';
import '../domain/tasks/load_feed_task.dart';
import '../domain/tasks/posts_task.dart';
import '../ui/posts/actions/write_post.dart';
import '../ui/posts/view_models/post_detail_view_model.dart';
import '../ui/posts/view_models/posts_view_model.dart';

final getIt = GetIt.instance;

/// Application composition root. Call once before building the app.
void configureDependencies(
  GetIt container, {
  AppConfig? appConfig,
  ApiConfig? apiConfig,
  AccessTokenProvider? accessTokenProvider,
}) {
  if (appConfig != null && apiConfig != null) {
    throw ArgumentError('Pass appConfig or apiConfig, not both.');
  }
  final config =
      appConfig ??
      AppConfig.fromEnvironment(api: apiConfig ?? const ApiConfig());
  config.validate();
  container.registerSingleton<AppConfig>(config);
  container.registerSingleton<ApiConfig>(config.api);
  container.registerLazySingleton<AppPackageInfo>(PlatformAppPackageInfo.new);
  container.registerLazySingleton<AppImagePicker>(PlatformAppImagePicker.new);
  container.registerLazySingleton<AppPreferences>(
    SharedPreferencesAppPreferences.new,
  );
  container.registerLazySingleton<Dio>(
    () => createDio(
      container<ApiConfig>(),
      accessTokenProvider: accessTokenProvider,
    ),
    dispose: (dio) => dio.close(force: true),
  );
  container.registerLazySingleton<ApiClient>(() => ApiClient(container<Dio>()));

  container.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSource(container<ApiClient>()),
  );
  container.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSource(container<ApiClient>()),
  );
  container.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      container<FeedRemoteDataSource>(),
      container<PostsRemoteDataSource>(),
    ),
  );

  container.registerFactoryParam<PostsTask, PostsRequest, void>(
    (request, _) => PostsTask(container<PostsRepository>(), request),
  );
  container.registerFactoryParam<WritePost, PostsRequest, void>(
    (request, _) => WritePost(container<PostsTask>(param1: request)),
  );
  container.registerFactory<PostsViewModel>(
    () => PostsViewModel(
      createFeedTask: (query, previous) =>
          container<LoadFeedTask>(param1: query, param2: previous),
    ),
  );
  container.registerFactoryParam<LoadFeedTask, FeedQuery, FeedPage?>(
    (query, previous) => LoadFeedTask(
      container<PostsRepository>(),
      query: query,
      previous: previous,
    ),
  );
  container.registerFactoryParam<LoadPostDetailTask, int, void>(
    (id, _) => LoadPostDetailTask(container<PostsRepository>(), id),
  );
  container.registerFactoryParam<PostDetailViewModel, int, void>(
    (id, _) => PostDetailViewModel(
      postId: id,
      createTask: (postId) => container<LoadPostDetailTask>(param1: postId),
    ),
  );
}
