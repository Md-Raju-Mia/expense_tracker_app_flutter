import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/routes/app_pages.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:fleet_wise_user_app/ui/posts/screens/posts_screen.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'support/feed_adapter.dart';

void main() {
  setUp(() {
    configureDependencies(getIt);
    getIt<Dio>().httpClientAdapter = FeedAdapter();
  });
  tearDown(() => getIt.reset());
  testWidgets('app opens the social feed automatically', (tester) async {
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    expect(find.byType(PostsScreen), findsOneWidget);
    expect(find.text('Your feed'), findsOneWidget);
    expect(find.text('A story from post 1'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
  testWidgets('posts deep link, disposal, and unknown route recovery', (
    tester,
  ) async {
    final router = AppPages.createRouter(initialLocation: '/posts');
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
    final model = tester
        .element(find.byType(PostsScreen))
        .read<PostsViewModel>();
    router.go('/missing');
    await tester.pumpAndSettle();
    expect(model.isDisposed, isTrue);
    expect(find.text('Page not found'), findsOneWidget);
    await tester.tap(find.text('Go to posts'));
    await tester.pumpAndSettle();
    expect(
      tester.element(find.byType(PostsScreen)).read<PostsViewModel>(),
      isNot(same(model)),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
