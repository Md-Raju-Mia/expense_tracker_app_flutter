import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/core/theme/app_theme.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:fleet_wise_user_app/ui/categories/screens/categories_screen.dart';
import 'package:fleet_wise_user_app/ui/categories/view_models/categories_view_model.dart';

import 'support/load_expense_fonts.dart';
import 'support/memory_categories.dart';

Future<CategoriesViewModel> showCategories(
  WidgetTester tester,
  MemoryCategories repository, {
  bool dark = false,
  bool bengali = false,
  double scale = 1,
}) async {
  final model = categoriesModel(repository);
  await model.load();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(bengali ? 'bn' : 'en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: ChangeNotifierProvider(
        create: (_) => model,
        child: const RepaintBoundary(
          key: ValueKey('categories-preview'),
          child: CategoriesScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return model;
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> saveCategoryPreview(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('categories-preview')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('build/$name.png').writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadExpenseFonts);
  testWidgets(
    'create/edit with icon and color, cancel, archive confirmation and restore',
    (tester) async {
      final repository = MemoryCategories();
      await showCategories(tester, repository);
      await tapVisible(tester, find.byKey(const ValueKey('category-add')));
      await tapVisible(tester, find.byKey(const ValueKey('category-save')));
      await tester.ensureVisible(find.byKey(const ValueKey('category-name')));
      await tester.pumpAndSettle();
      expect(find.text('Enter a name with 1–60 characters.'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('category-name')),
        'Rent',
      );
      await tapVisible(
        tester,
        find.byKey(const ValueKey('category-icon-home')),
      );
      await tapVisible(
        tester,
        find.byKey(const ValueKey('category-color-indigo')),
      );
      await tapVisible(tester, find.byKey(const ValueKey('category-save')));
      expect(repository.rows.last.icon, CategoryIcon.home);
      expect(repository.rows.last.color, CategoryColor.indigo);
      await tapVisible(
        tester,
        find.descendant(
          of: find.byKey(ValueKey(repository.rows.last.id)),
          matching: find.text('Edit category'),
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('category-name')),
        'Monthly rent',
      );
      await tapVisible(tester, find.byKey(const ValueKey('category-save')));
      expect(repository.rows.last.name, 'Monthly rent');
      final card = find.byKey(ValueKey(repository.rows.last.id));
      await tapVisible(
        tester,
        find.descendant(of: card, matching: find.text('Archive')),
      );
      await tapVisible(tester, find.text('Cancel'));
      expect(repository.rows.last.isArchived, isFalse);
      await tapVisible(
        tester,
        find.descendant(of: card, matching: find.text('Archive')),
      );
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Archive'));
      expect(repository.rows.last.isArchived, isTrue);
      await tapVisible(tester, find.text('Archived'));
      await tapVisible(tester, find.text('Restore'));
      expect(repository.rows.last.isArchived, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'write failure shows friendly error and retains the name for retry',
    (tester) async {
      final repository = MemoryCategories()
        ..writeError = const CategoryException(CategoryProblem.duplicateName);
      await showCategories(tester, repository);
      await tapVisible(tester, find.byKey(const ValueKey('category-add')));
      await tester.enterText(
        find.byKey(const ValueKey('category-name')),
        'Rent',
      );
      await tapVisible(tester, find.byKey(const ValueKey('category-save')));
      expect(
        find.text(
          'An active category with this name already exists for this transaction type.',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byKey(const ValueKey('category-name')));
      await tester.pumpAndSettle();
      expect(find.text('Rent'), findsOneWidget);
      repository.writeError = null;
      await tapVisible(tester, find.byKey(const ValueKey('category-save')));
      expect(repository.rows.last.name, 'Rent');
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('duplicate translated names are blocked before a write', (
    tester,
  ) async {
    final repository = MemoryCategories();
    await showCategories(tester, repository, bengali: true);
    await tapVisible(tester, find.byKey(const ValueKey('category-add')));
    await tester.enterText(
      find.byKey(const ValueKey('category-name')),
      'খাবার',
    );
    await tapVisible(tester, find.byKey(const ValueKey('category-save')));
    await tester.ensureVisible(find.byKey(const ValueKey('category-name')));
    await tester.pumpAndSettle();
    expect(
      find.text('এই ধরনের লেনদেনের জন্য একই নামের একটি সক্রিয় বিভাগ রয়েছে।'),
      findsOneWidget,
    );
    expect(repository.writes, 0);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('initial read failure offers retry', (tester) async {
    final repository = MemoryCategories()..readError = StateError('storage');
    await showCategories(tester, repository);
    expect(
      find.text('Could not refresh categories. Try again.'),
      findsOneWidget,
    );
    repository.readError = null;
    await tapVisible(tester, find.text('Try again'));
    expect(find.text('Food'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final dark in [false, true]) {
    for (final bengali in [false, true]) {
      testWidgets(
        '320px 2x text list and editor: dark=$dark Bengali=$bengali',
        (tester) async {
          tester.view.physicalSize = const Size(320, 640);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await showCategories(
            tester,
            MemoryCategories(),
            dark: dark,
            bengali: bengali,
            scale: 2,
          );
          expect(tester.takeException(), isNull);
          await tapVisible(tester, find.byKey(const ValueKey('category-add')));
          await tester.enterText(
            find.byKey(const ValueKey('category-name')),
            'Rent',
          );
          await tapVisible(
            tester,
            find.byKey(const ValueKey('category-icon-education')),
          );
          await tapVisible(
            tester,
            find.byKey(const ValueKey('category-color-teal')),
          );
          await tapVisible(tester, find.byKey(const ValueKey('category-save')));
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }

  testWidgets('phone preview', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await showCategories(tester, MemoryCategories());
    if (const bool.fromEnvironment('SAVE_CATEGORIES_PREVIEW')) {
      await saveCategoryPreview(tester, 'categories-preview');
      await tapVisible(tester, find.byKey(const ValueKey('category-add')));
      await tester.enterText(
        find.byKey(const ValueKey('category-name')),
        'Monthly rent',
      );
      await tester.pumpAndSettle();
      await saveCategoryPreview(tester, 'category-editor-preview');
    }
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
