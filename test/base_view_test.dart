import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'dart:async';

import 'package:fleet_wise_user_app/core/base/base_view.dart';
import 'package:fleet_wise_user_app/core/base/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/test_actions.dart';

class TestViewModel extends BaseViewModel {}

class TestView extends BaseView<TestViewModel> {
  const TestView({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  PreferredSizeWidget appBar(BuildContext context, TestViewModel viewModel) =>
      AppBar(title: const Text('Test screen'));

  @override
  Widget body(BuildContext context, TestViewModel viewModel) => Center(
    child: TextButton(onPressed: onTap, child: const Text('Body action')),
  );

  @override
  Widget floatingActionButton(BuildContext context, TestViewModel viewModel) =>
      FloatingActionButton(onPressed: onTap, child: const Icon(Icons.add));

  @override
  Widget bottomNavigationBar(BuildContext context, TestViewModel viewModel) =>
      TextButton(onPressed: onTap, child: const Text('Navigation action'));
}

void main() {
  testWidgets('loading blocks screen actions and clears after completion', (
    tester,
  ) async {
    final model = TestViewModel();
    addTearDown(model.dispose);
    var taps = 0;
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestView(onTap: () => taps++),
        ),
      ),
    );
    expect(find.text('Test screen'), findsOneWidget);
    expect(find.byType(SafeArea), findsWidgets);
    await tester.tap(find.text('Body action'));
    expect(taps, 1);

    final gate = Completer<void>();
    final pending = model.execute(TestAction(TestTask('test', gate: gate)));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    for (final target in [
      find.text('Body action'),
      find.byType(FloatingActionButton),
      find.text('Navigation action'),
    ]) {
      await tester.tap(target, warnIfMissed: false);
    }
    expect(taps, 1);

    gate.complete();
    await pending;
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.text('Body action'));
    expect(taps, 2);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(model.isDisposed, isFalse); // Provider.value retains ownership.
  });

  testWidgets('shared error renders once and clears on retry', (tester) async {
    final model = TestViewModel();
    addTearDown(model.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestView(onTap: () {}),
        ),
      ),
    );
    await model.execute(
      TestAction(TestTask('GPS', error: StateError('offline'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Operation failed. Please try again.'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    final gate = Completer<void>();
    final pending = model.execute(TestAction(TestTask('GPS', gate: gate)));
    await tester.pump();
    expect(find.text('Operation failed. Please try again.'), findsNothing);
    gate.complete();
    await pending;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
