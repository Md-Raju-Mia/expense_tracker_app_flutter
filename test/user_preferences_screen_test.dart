import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/core/theme/app_theme.dart';
import 'package:fleet_wise_user_app/domain/entities/user_country.dart';
import 'package:fleet_wise_user_app/domain/entities/user_currency.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:fleet_wise_user_app/ui/preferences/screens/user_preferences_screen.dart';

import 'support/load_expense_fonts.dart';
import 'support/memory_user_preferences.dart';

const englishPreferences = UserPreferences(
  country: UserCountry.unitedStates,
  currency: UserCurrency.usd,
  language: UserLanguage.english,
);

Future<void> showPreferences(
  WidgetTester tester,
  MemoryUserPreferences repository, {
  ValueChanged<UserPreferences>? onSaved,
  bool dark = false,
  double scale = 1,
}) async {
  final model = preferencesModel(repository);
  await model.load();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: RepaintBoundary(
        key: const ValueKey('preferences-preview'),
        child: ChangeNotifierProvider(
          create: (_) => model,
          child: UserPreferencesScreen(onSaved: onSaved ?? (_) {}),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadExpenseFonts);

  testWidgets(
    'country suggestions, independent overrides and successful save',
    (tester) async {
      final repository = MemoryUserPreferences(englishPreferences);
      UserPreferences? applied;
      await showPreferences(
        tester,
        repository,
        onSaved: (preferences) => applied = preferences,
      );
      await tester.tap(find.byType(DropdownButtonFormField<UserCountry>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bangladesh').last);
      await tester.pumpAndSettle();
      expect(find.text('আপনার পছন্দ'), findsWidgets);
      expect(find.text('বাংলাদেশি টাকা (BDT)'), findsOneWidget);
      await tester.ensureVisible(
        find.byType(DropdownButtonFormField<UserCurrency>),
      );
      await tester.tap(find.byType(DropdownButtonFormField<UserCurrency>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('মার্কিন ডলার (USD)').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byType(DropdownButtonFormField<UserLanguage>),
      );
      await tester.tap(find.byType(DropdownButtonFormField<UserLanguage>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save preferences'));
      await tester.tap(find.text('Save preferences'));
      await tester.pumpAndSettle();
      expect(applied!.country, UserCountry.bangladesh);
      expect(applied!.currency, UserCurrency.usd);
      expect(applied!.language, UserLanguage.english);
      expect(repository.saved.currency, UserCurrency.usd);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  for (final dark in [false, true]) {
    for (final bengali in [false, true]) {
      testWidgets(
        '320px layout and 2x text remain usable: dark=$dark Bengali=$bengali',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 640));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final repository = MemoryUserPreferences(
            bengali ? const UserPreferences() : englishPreferences,
          );
          var saved = false;
          await showPreferences(
            tester,
            repository,
            dark: dark,
            scale: 2,
            onSaved: (_) => saved = true,
          );
          final label = bengali ? 'পছন্দ সংরক্ষণ করুন' : 'Save preferences';
          await tester.ensureVisible(find.text(label));
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          expect(saved, isTrue);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }

  testWidgets('storage failure is visible and does not claim success', (
    tester,
  ) async {
    final repository = MemoryUserPreferences(englishPreferences)
      ..saveError = StateError('disk full');
    var saved = false;
    await showPreferences(tester, repository, onSaved: (_) => saved = true);
    await tester.ensureVisible(find.text('Save preferences'));
    await tester.tap(find.text('Save preferences'));
    await tester.pumpAndSettle();
    expect(saved, isFalse);
    expect(
      find.text('Could not load or save preferences. Please try again.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('readable light-theme phone preview', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await showPreferences(tester, MemoryUserPreferences(englishPreferences));
    final colors = Theme.of(tester.element(find.byType(FilledButton)))
        .colorScheme;
    final contrast =
        (colors.onPrimary.computeLuminance() + .05) /
        (colors.primary.computeLuminance() + .05);
    expect(contrast, greaterThanOrEqualTo(4.5));
    expect(tester.takeException(), isNull);
    if (const bool.fromEnvironment('SAVE_PREFERENCES_PREVIEW')) {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('preferences-preview')),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await Directory('build').create(recursive: true);
        await File('build/preferences-preview.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
