import 'dart:convert';
import 'dart:io';

import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/ui/posts/screens/posts_screen.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/test_actions.dart';
import 'support/feed_adapter.dart';

import 'package:dio/dio.dart';

void main() {
  setUp(() {
    configureDependencies(getIt);
    getIt<Dio>().httpClientAdapter = FeedAdapter();
  });
  tearDown(() => getIt.reset());

  test('all translations contain the same message keys', () {
    Set<String> keys(String file) =>
        (jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>).keys
            .where((key) => !key.startsWith('@'))
            .toSet();
    expect(keys('lib/l10n/app_bn.arb'), keys('lib/l10n/app_en.arb'));
  });

  test('iOS image-picker permission messages cover supported locales', () {
    for (final locale in ['en', 'bn']) {
      final strings = File('ios/Runner/$locale.lproj/InfoPlist.strings')
          .readAsStringSync();
      expect(strings, contains('NSCameraUsageDescription'));
      expect(strings, contains('NSPhotoLibraryUsageDescription'));
    }
  });

  testWidgets(
    'device locale changes update UI and error messages; unknown locale falls back to English',
    (tester) async {
      final platform = tester.binding.platformDispatcher;
      addTearDown(platform.clearLocalesTestValue);
      platform.localesTestValue = [const Locale('en')];
      await tester.pumpWidget(const PostsApp());
      await tester.pumpAndSettle();
      expect(find.text('Your feed'), findsOneWidget);
      final model = tester
          .element(find.byType(PostsScreen))
          .read<PostsViewModel>();
      await model.execute(
        TestAction(TestTask('GPS', error: StateError('offline'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('Operation failed. Please try again.'), findsOneWidget);
      platform.localesTestValue = [const Locale('bn', 'BD')];
      await tester.pumpAndSettle();
      expect(find.text('আপনার ফিড'), findsOneWidget);
      expect(
        find.text('কার্যক্রম ব্যর্থ হয়েছে। আবার চেষ্টা করুন।'),
        findsOneWidget,
      );
      expect(
        tester.element(find.byType(PostsScreen)).read<PostsViewModel>(),
        same(model),
      );
      platform.localesTestValue = [const Locale('fr')];
      await tester.pumpAndSettle();
      expect(find.text('Your feed'), findsOneWidget);
      expect(
        Localizations.localeOf(tester.element(find.byType(PostsScreen)))
            .languageCode,
        'en',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Bengali posts flow fits narrow screens with large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final platform = tester.binding.platformDispatcher;
    platform.localesTestValue = [const Locale('bn')];
    platform.textScaleFactorTestValue = 2;
    addTearDown(platform.clearLocalesTestValue);
    addTearDown(platform.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const PostsApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('আপনার ফিড'));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
