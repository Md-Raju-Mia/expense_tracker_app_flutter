import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/ui/posts/actions/write_post.dart';
import 'package:fleet_wise_user_app/domain/entities/posts_request.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:fleet_wise_user_app/core/utils/platform/app_image_picker.dart';
import 'package:fleet_wise_user_app/core/utils/platform/app_package_info.dart';
import 'package:fleet_wise_user_app/core/storage/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('models and write attempts have independent lifetimes', () async {
    final container = GetIt.asNewInstance();
    configureDependencies(container);
    addTearDown(container.reset);
    expect(container.isRegistered<AppPackageInfo>(), isTrue);
    expect(container.isRegistered<AppImagePicker>(), isTrue);
    expect(container.isRegistered<AppPreferences>(), isTrue);
    final first = container<PostsViewModel>();
    final second = container<PostsViewModel>();
    expect(first, isNot(same(second)));
    first.dispose();
    expect(second.isDisposed, isFalse);
    second.dispose();
    const request = PostsRequest(
      operation: PostsOperation.add,
      title: 'A',
      body: 'B',
    );
    final action = container<WritePost>(param1: request);
    final next = container<WritePost>(param1: request);
    expect(action, isNot(same(next)));
    expect(action.task, isNot(same(next.task)));
    expect(action.task.repository, same(next.task.repository));
    expect(action.result, isNull);
  });
}
