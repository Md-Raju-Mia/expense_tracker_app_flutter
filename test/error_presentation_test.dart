import 'package:fleet_wise_user_app/core/base/base_view.dart';
import 'package:fleet_wise_user_app/core/base/base_view_model.dart';
import 'package:fleet_wise_user_app/core/network/api_exception.dart';
import 'package:fleet_wise_user_app/core/theme/app_theme.dart';
import 'package:fleet_wise_user_app/ui/posts/view_models/posts_view_model.dart';
import 'package:fleet_wise_user_app/ui/posts/screens/posts_screen.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/test_actions.dart';
import 'support/feed_adapter.dart';

class _Model extends BaseViewModel {}

class _CustomView extends BaseView<_Model> {
  const _CustomView();

  @override
  String? errorMessage(BuildContext context, _Model viewModel) =>
      viewModel.state.error == null ? null : context.l10n.networkForbidden;

  @override
  Widget body(BuildContext context, _Model viewModel) => const SizedBox();
}

void main() {
  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('posts errors in $locale / $brightness at large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final platform = tester.binding.platformDispatcher;
        platform.localesTestValue = [Locale(locale)];
        platform.textScaleFactorTestValue = 2;
        addTearDown(platform.clearLocalesTestValue);
        addTearDown(platform.clearTextScaleFactorTestValue);
        final model = PostsViewModel(createFeedTask: (_, _) => EmptyFeedTask());
        await model.initialize();
        addTearDown(model.dispose);
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: model,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: brightness == Brightness.light
                  ? AppTheme.light
                  : AppTheme.dark,
              home: const PostsScreen(),
            ),
          ),
        );
        final strings = tester.element(find.byType(PostsScreen)).l10n;
        for (final entry in {
          'GPS': strings.operation,
          'Path finder': strings.operation,
          'Engine ignition': strings.operation,
          'Upload': strings.operation,
          'private diagnostic task': strings.operation,
        }.entries) {
          await model.execute(
            TestAction(TestTask(entry.key, error: StateError('secret'))),
          );
          await tester.pumpAndSettle();
          expect(
            find.text(strings.operationFailed(entry.value)),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        }
        final messages = {
          ApiErrorKind.timeout: strings.networkTimeout,
          ApiErrorKind.connection: strings.networkConnection,
          ApiErrorKind.cancelled: strings.networkCancelled,
          ApiErrorKind.certificate: strings.networkCertificate,
          ApiErrorKind.unauthorized: strings.networkUnauthorized,
          ApiErrorKind.forbidden: strings.networkForbidden,
          ApiErrorKind.notFound: strings.networkNotFound,
          ApiErrorKind.rateLimited: strings.networkRateLimited,
          ApiErrorKind.server: strings.networkServer,
          ApiErrorKind.response: strings.networkResponse,
          ApiErrorKind.invalidData: strings.networkInvalidData,
          ApiErrorKind.unknown: strings.operationFailed(strings.operation),
        };
        expect(messages.keys.toSet(), ApiErrorKind.values.toSet());
        for (final entry in messages.entries) {
          final failure = ApiException(
            entry.key,
            'secret server payload',
            cause: StateError('secret'),
          );
          final outcome = await model.execute(
            TestAction(TestTask('Upload', error: failure)),
          );
          await tester.pumpAndSettle();
          expect(find.text(entry.value), findsOneWidget);
          expect(find.textContaining('secret'), findsNothing);
          expect(outcome.error, same(failure));
          expect(outcome.stackTrace, isNotNull);
          expect(outcome.failedTask, 'Upload');
          expect(tester.takeException(), isNull);
        }
        // Reformat an existing failure when the system locale changes.
        await model.execute(
          TestAction(
            TestTask(
              'Upload',
              error: const ApiException(ApiErrorKind.timeout, 'secret'),
            ),
          ),
        );
        platform.localesTestValue = [const Locale('bn')];
        await tester.pumpAndSettle();
        expect(find.text('অনুরোধের সময়সীমা শেষ হয়েছে।'), findsOneWidget);
        platform.localesTestValue = [const Locale('fr')];
        await tester.pumpAndSettle();
        expect(find.text('The request timed out.'), findsOneWidget);
        expect(model.resetState(), isTrue);
        await tester.pumpAndSettle();
        expect(find.text('The request timed out.'), findsNothing);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  testWidgets(
    'feature can override message formatting without changing the shell',
    (tester) async {
      final model = _Model();
      addTearDown(model.dispose);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: model,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: _CustomView(),
          ),
        ),
      );
      expect(
        find.text('You do not have permission for this request.'),
        findsNothing,
      );
      await model.execute(
        TestAction(TestTask('private', error: StateError('secret'))),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('You do not have permission for this request.'),
        findsOneWidget,
      );
      expect(find.textContaining('secret'), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
