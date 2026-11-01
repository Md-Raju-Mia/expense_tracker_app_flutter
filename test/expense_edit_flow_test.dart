import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_save_action.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_update_action.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/repositories/category_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/load_expense_form_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/save_expense_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/update_expense_task.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_form_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_home_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_form_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';

import 'support/form_expenses.dart';
import 'support/memory_categories.dart';
import 'support/memory_user_preferences.dart';
import 'support/test_categories.dart';
import 'support/load_expense_fonts.dart';

Expense original({
  int id = 1,
  TransactionCategory category = TestCategories.food,
}) => Expense(
  id: id,
  syncId: 'stable-$id',
  currencyCode: 'USD',
  title: 'Original lunch',
  amountMinor: 1250,
  date: DateTime(2019, 4, 9, 12, 30),
  category: category,
);

ExpenseFormViewModel editModel(
  FormExpenses repository,
  MemoryCategories categories,
) => ExpenseFormViewModel(
  transactionId: 1,
  currencyCode: 'BDT',
  createLoadTask: () =>
      LoadExpenseFormTask(repository, categories, transactionId: 1),
  createSaveAction: (expense) =>
      ExpenseSaveAction(SaveExpenseTask(repository, expense)),
  createUpdateAction: (expense) =>
      ExpenseUpdateAction(UpdateExpenseTask(repository, expense)),
);

void main() {
  setUpAll(loadExpenseFonts);
  test('edit preloads original currency/date/category and refresh does not overwrite draft selections', () async {
    final repository = FormExpenses()..rows.add(original());
    final categories = MemoryCategories(allDefaults: true);
    final model = editModel(repository, categories);
    addTearDown(model.dispose);
    await model.load();
    expect(model.isEditing, isTrue);
    expect(model.currencyCode, 'USD');
    expect(model.initialTitle, 'Original lunch');
    expect(model.initialAmountMinor, 1250);
    expect(model.selectedDate, original().date);
    model.selectDate(DateTime(2026, 1, 1));
    model.selectCategory(TestCategories.transport);
    await model.load();
    expect(model.selectedDate, DateTime(2026, 1, 1));
    expect(model.selectedCategory!.id, 'default-transport');
    expect(
      (await model.save(title: 'Train', amountMinor: 29)).status,
      ActionStatus.succeeded,
    );
    expect(repository.rows, hasLength(1));
    expect(repository.updates, 1);
    expect(repository.rows.single.syncId, 'stable-1');
    expect(repository.rows.single.currencyCode, 'USD');
  });

  test('archived original category remains editable but other archived choices stay hidden', () async {
    final categories = MemoryCategories(allDefaults: true);
    await categories.setArchived('default-food', true);
    await categories.setArchived('default-health', true);
    final archived = categories.rows.singleWhere(
      (row) => row.id == 'default-food',
    );
    final repository = FormExpenses()..rows.add(original(category: archived));
    final model = editModel(repository, categories);
    addTearDown(model.dispose);
    await model.load();
    expect(model.selectedCategory!.isArchived, isTrue);
    expect(model.canSave, isTrue);
    expect(
      model.availableCategories.any((row) => row.id == 'default-health'),
      isFalse,
    );
    expect(
      (await model.save(title: 'Corrected', amountMinor: 29)).status,
      ActionStatus.succeeded,
    );
    expect(repository.rows.single.category.id, 'default-food');
  });

  test(
    'busy save rejects duplicates and accepted update finishes after disposal',
    () async {
      final repository = FormExpenses()
        ..rows.add(original())
        ..pendingSave = Completer<int>();
      final model = editModel(repository, MemoryCategories(allDefaults: true));
      await model.load();
      var notifications = 0;
      model.addListener(() => notifications++);
      final pending = model.save(title: 'Corrected', amountMinor: 29);
      await expectLater(
        model.save(title: 'Duplicate', amountMinor: 30),
        throwsStateError,
      );
      model.dispose();
      final before = notifications;
      repository.pendingSave!.complete(1);
      expect((await pending).status, ActionStatus.succeeded);
      expect(repository.updates, 1);
      expect(notifications, before);
    },
  );

  group('edit screens', () {
    late FormExpenses expenses;
    setUp(() async {
      configureDependencies(getIt);
      expenses = FormExpenses()..rows.add(original());
      await getIt.unregister<ExpenseRepository>();
      getIt.registerSingleton<ExpenseRepository>(expenses);
      await getIt.unregister<CategoryRepository>();
      getIt.registerSingleton<CategoryRepository>(
        MemoryCategories(allDefaults: true),
      );
      await getIt.unregister<UserPreferencesRepository>();
      getIt.registerSingleton<UserPreferencesRepository>(
        MemoryUserPreferences(
          const UserPreferences(language: UserLanguage.english),
        ),
      );
    });
    tearDown(() => getIt.reset());

    Future<void> open(
      WidgetTester tester, {
      String path = '/expenses/1/edit',
    }) async {
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('edit-preview'),
          child: ExpenseTrackerApp(initialLocation: path),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> tap(WidgetTester tester, Finder finder) async {
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    testWidgets(
      'pencil opens prefilled form; save updates one row and refreshes Home',
      (tester) async {
        await open(tester, path: '/expenses');
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('edit-expense-1')),
          200,
        );
        await tap(tester, find.byKey(const ValueKey('edit-expense-1')));
        expect(find.text('Edit transaction'), findsOneWidget);
        expect(find.text('Original lunch'), findsOneWidget);
        expect(find.text('12.50'), findsOneWidget);
        expect(find.text('Amount (USD)'), findsOneWidget);
        await tester.enterText(find.byType(TextFormField).at(0), 'Train');
        await tester.enterText(find.byType(TextFormField).at(1), '২৯.২৫');
        await tap(
          tester,
          find.byKey(const ValueKey('expense-category-default-transport')),
        );
        await tap(tester, find.text('Save changes'));
        expect(expenses.updates, 1);
        expect(expenses.rows, hasLength(1));
        expect(expenses.rows.single.amountMinor, 2925);
        expect(expenses.rows.single.currencyCode, 'USD');
        expect(expenses.rows.single.syncId, 'stable-1');
        final home = tester
            .element(find.byType(ExpenseHomeScreen))
            .read<ExpenseHomeViewModel>();
        expect(home.expenses.single.title, 'Train');
        expect(home.contentState.data!.totalExpenseMinor, BigInt.zero);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'Back cancels edits; date picker supports the original pre-2020 date',
      (tester) async {
        await open(tester);
        await tester.enterText(find.byType(TextFormField).at(0), 'Unsaved');
        await tap(tester, find.byIcon(Icons.calendar_month));
        final picker = tester.widget<DatePickerDialog>(
          find.byType(DatePickerDialog),
        );
        expect(picker.initialDate, DateTime(2019, 4, 9));
        expect(picker.firstDate, DateTime(2019));
        await tap(tester, find.text('Cancel'));
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(expenses.rows.single.title, 'Original lunch');
        expect(expenses.updates, 0);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets('failed update retains draft and explicit retry succeeds', (
      tester,
    ) async {
      expenses.saveError = StateError('disk');
      await open(tester);
      await tester.enterText(find.byType(TextFormField).at(0), 'Corrected');
      await tester.enterText(find.byType(TextFormField).at(1), '0.29');
      await tap(tester, find.text('Save changes'));
      expect(find.byType(ExpenseFormScreen), findsOneWidget);
      expect(
        find.text(
          'Could not save the transaction. Your entries are kept here; try again.',
        ),
        findsOneWidget,
      );
      expect(expenses.rows.single.title, 'Original lunch');
      await tester.ensureVisible(find.byType(TextFormField).at(0));
      await tester.pumpAndSettle();
      expect(find.text('Corrected'), findsOneWidget);
      expect(find.text('0.29'), findsOneWidget);
      expenses.saveError = null;
      await tap(tester, find.text('Save changes'));
      expect(expenses.rows.single.title, 'Corrected');
      expect(expenses.updates, 1);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
      'deleted draft and missing deep link show not-found without inserting',
      (tester) async {
        await open(tester);
        expenses.rows.clear();
        await tap(tester, find.text('Save changes'));
        expect(
          find.text(
            'This transaction no longer exists. Go back to your transactions.',
          ),
          findsOneWidget,
        );
        expect(expenses.rows, isEmpty);
        expect(expenses.updates, 0);
        await tester.pumpWidget(const SizedBox.shrink());
        await open(tester, path: '/expenses/999/edit');
        expect(
          find.text(
            'This transaction no longer exists. Go back to your transactions.',
          ),
          findsOneWidget,
        );
        expect(find.byType(TextFormField), findsNothing);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'archived original category survives manager navigation and edit save',
      (tester) async {
        final categories = getIt<CategoryRepository>() as MemoryCategories;
        await categories.setArchived('default-food', true);
        expenses.rows[0] = original(
          category: categories.rows.singleWhere(
            (row) => row.id == 'default-food',
          ),
        );
        await open(tester);
        expect(find.text('Food (archived)'), findsOneWidget);
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Kept archive',
        );
        await tap(tester, find.text('Manage categories'));
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.text('Kept archive'), findsOneWidget);
        await tap(tester, find.text('Save changes'));
        expect(expenses.rows.single.category.id, 'default-food');
        expect(expenses.rows.single.category.isArchived, isTrue);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'Bengali edit layout and exact amount input work at 320px with 2x text',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(
          tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
        );
        await getIt<UserPreferencesRepository>().save(const UserPreferences());
        await open(tester);
        expect(find.text('লেনদেন সম্পাদনা'), findsOneWidget);
        await tester.enterText(find.byType(TextFormField).at(1), '০.২৯');
        await tap(tester, find.text('পরিবর্তন সংরক্ষণ করুন'));
        expect(expenses.rows.single.amountMinor, 29);
        expect(expenses.rows.single.currencyCode, 'USD');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets('edit preview', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await open(tester);
      if (const bool.fromEnvironment('SAVE_EDIT_PREVIEW')) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('edit-preview')),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('build/expense-edit-preview.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
