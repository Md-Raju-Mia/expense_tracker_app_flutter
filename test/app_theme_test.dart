import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/ui/posts/screens/posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'support/feed_adapter.dart';

void main() {
  setUp(() {
    configureDependencies(getIt);
    getIt<Dio>().httpClientAdapter = FeedAdapter();
  });
  tearDown(() => getIt.reset());

  testWidgets('global theme follows system brightness on the posts route', (
    tester,
  ) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearPlatformBrightnessTestValue);
    dispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    final light = Theme.of(tester.element(find.byType(PostsScreen)));
    expect(light.brightness, Brightness.light);
    dispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    final dark = Theme.of(tester.element(find.byType(PostsScreen)));
    expect(dark.brightness, Brightness.dark);
    expect(dark.colorScheme.surface, isNot(light.colorScheme.surface));
    expect(find.text('Your feed'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('posts content supports narrow screens and enlarged text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Your feed'));
    expect(tester.takeException(), isNull);
    expect(find.byType(ListView), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
