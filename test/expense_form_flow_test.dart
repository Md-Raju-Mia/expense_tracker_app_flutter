import 'package:fleet_wise_user_app/domain/repositories/category_repository.dart';

import 'support/memory_categories.dart';
import 'support/test_categories.dart';

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/domain/entities/user_country.dart';
import 'package:fleet_wise_user_app/domain/entities/user_currency.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';

import 'support/memory_user_preferences.dart';
import 'support/form_expenses.dart';

import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_form_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_home_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_form_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/widgets/expense_category_picker.dart';

import 'support/load_expense_fonts.dart';

Future<void> savePreview(WidgetTester tester, String name) async {
  if (!const bool.fromEnvironment('SAVE_EXPENSE_PREVIEW')) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('app-preview')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('build/$name.png').writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> openApp(WidgetTester tester, {String? initialLocation}) async {
  await tester.pumpWidget(
    RepaintBoundary(
      key: const ValueKey('app-preview'),
      child: ExpenseTrackerApp(initialLocation: initialLocation),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tapSave(WidgetTester tester) async {
  final save = find.text('Save Transaction');
  await tester.ensureVisible(save);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadExpenseFonts);
  late FormExpenses repository;
  setUp(() async {
    configureDependencies(getIt);
    await getIt.unregister<CategoryRepository>();
    getIt.registerSingleton<CategoryRepository>(
      MemoryCategories(allDefaults: true),
    );
    await getIt.unregister<UserPreferencesRepository>();
    getIt.registerSingleton<UserPreferencesRepository>(
      MemoryUserPreferences(
        const UserPreferences(
          country: UserCountry.unitedStates,
          currency: UserCurrency.usd,
          language: UserLanguage.english,
        ),
      ),
    );
    repository = FormExpenses();
    await getIt.unregister<ExpenseRepository>();
    getIt.registerSingleton<ExpenseRepository>(repository);
  });
  tearDown(() => getIt.reset());

  testWidgets('startup home, validation, wait for save and home reload', (
    tester,
  ) async {
    await openApp(tester);
    expect(find.byType(ExpenseHomeScreen), findsOneWidget);
    final home = tester
        .element(find.byType(ExpenseHomeScreen))
        .read<ExpenseHomeViewModel>();
    await tester.tap(find.text('Add Transaction'));
    await tester.pumpAndSettle();
    await tapSave(tester);
    expect(find.text('Please enter a title'), findsOneWidget);
    expect(
      find.text('Enter a positive amount with up to 2 decimal places.'),
      findsOneWidget,
    );
    expect(repository.rows, isEmpty);
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
    await tester.enterText(find.byType(TextFormField).at(1), '12.5');
    repository.pendingSave = Completer<int>();
    final form = tester
        .element(find.byType(ExpenseFormScreen))
        .read<ExpenseFormViewModel>();
    await tester.ensureVisible(find.text('Save Transaction'));
    await tester.tap(find.text('Save Transaction'));
    await tester.pump();
    expect(find.byType(ExpenseFormScreen), findsOneWidget);
    expect(repository.rows, isEmpty);
    expect(form.isDisposed, isFalse);
    repository.pendingSave!.complete(1);
    await tester.pumpAndSettle();
    expect(
      tester
          .element(find.byType(ExpenseHomeScreen))
          .read<ExpenseHomeViewModel>(),
      same(home),
    );
    expect(home.expenses.single.title, 'Lunch');
    expect(repository.rows.single.category, TestCategories.food);
    expect(repository.rows.single.amountMinor, 1250);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(home.isDisposed, isTrue);
  });

  testWidgets(
    'form toggle retains fields and separate expense/income selections',
    (tester) async {
      await openApp(tester, initialLocation: '/expenses/add');
      await tester.enterText(find.byType(TextFormField).at(0), 'Salary');
      await tester.enterText(find.byType(TextFormField).at(1), '100');
      await tester.tap(find.text('Shopping'));
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      expect(find.byType(ExpenseCategoryPicker), findsOneWidget);
      await tester.tap(find.text('Expense'));
      await tester.pumpAndSettle();
      final form = tester
          .element(find.byType(ExpenseFormScreen))
          .read<ExpenseFormViewModel>();
      expect(form.selectedCategory, TestCategories.shopping);
      expect(find.text('Salary'), findsOneWidget);
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      await tapSave(tester);
      expect(repository.rows.single.isIncome, isTrue);
      expect(repository.rows.single.category, TestCategories.income);
      final home = tester
          .element(find.byType(ExpenseHomeScreen))
          .read<ExpenseHomeViewModel>();
      expect(home.contentState.data!.totalIncomeMinor, BigInt.from(10000));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'blank titles are blocked and Bengali input is normalized on save',
    (tester) async {
      await openApp(tester, initialLocation: '/expenses/add');
      await tester.enterText(find.byType(TextFormField).at(0), '   ');
      await tester.enterText(find.byType(TextFormField).at(1), '১২.৫০');
      await tapSave(tester);
      expect(repository.rows, isEmpty);
      expect(find.text('Please enter a title'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(0), '  Lunch  ');
      await tapSave(tester);
      expect(repository.rows.single.title, 'Lunch');
      expect(repository.rows.single.amountMinor, 1250);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('invalid amount strings stay on the form without saving', (
    tester,
  ) async {
    await openApp(tester, initialLocation: '/expenses/add');
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
    for (final amount in [
      '0',
      '-5',
      'NaN',
      'Infinity',
      '1.234',
      '1,000.00',
      '10000000000000',
    ]) {
      await tester.enterText(find.byType(TextFormField).at(1), amount);
      await tapSave(tester);
      expect(repository.rows, isEmpty, reason: amount);
      expect(find.byType(ExpenseFormScreen), findsOneWidget);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'date picker range, cancellation, selection and back without saving',
    (tester) async {
      await openApp(tester, initialLocation: '/expenses/add');
      final model = tester
          .element(find.byType(ExpenseFormScreen))
          .read<ExpenseFormViewModel>();
      final original = model.selectedDate;
      await tester.ensureVisible(find.byIcon(Icons.calendar_month));
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      final picker = tester.widget<DatePickerDialog>(
        find.byType(DatePickerDialog),
      );
      expect(picker.firstDate, DateTime(2020));
      expect(DateUtils.isSameDay(picker.lastDate, DateTime.now()), isTrue);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(model.selectedDate, original);
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(model.selectedDate, DateUtils.dateOnly(original));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(repository.rows, isEmpty);
      expect(find.byType(ExpenseHomeScreen), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('failed save keeps the form and inputs for retry', (
    tester,
  ) async {
    repository.saveError = StateError('disk full');
    await openApp(tester, initialLocation: '/expenses/add');
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
    await tester.enterText(find.byType(TextFormField).at(1), '10');
    await tapSave(tester);
    expect(find.byType(ExpenseFormScreen), findsOneWidget);
    expect(
      find.text(
        'Could not save the transaction. Your entries are kept here; try again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Lunch'), findsOneWidget);
    expect(repository.rows, isEmpty);
    repository.saveError = null;
    await tapSave(tester);
    expect(repository.rows.single.title, 'Lunch');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('unknown route recovers to expense home', (tester) async {
    await openApp(tester, initialLocation: '/missing');
    await tester.tap(find.text('Go to expense tracker'));
    await tester.pumpAndSettle();
    expect(find.byType(ExpenseHomeScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('phone form previews retain English and light theme', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.binding.platformDispatcher.localesTestValue = [const Locale('bn')];
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
    addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
    );
    await openApp(tester, initialLocation: '/expenses/add');
    expect(find.text('Add Transaction'), findsOneWidget);
    expect(
      tester.widget<Title>(find.byType(Title).first).title,
      'Expense Tracker',
    );
    expect(
      Theme.of(tester.element(find.text('Add Transaction'))).brightness,
      Brightness.light,
    );
    expect(tester.takeException(), isNull);
    await savePreview(tester, 'expense_form_preview');
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();
    await savePreview(tester, 'income_form_preview');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
