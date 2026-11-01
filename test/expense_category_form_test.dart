import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_save_action.dart';
import 'package:fleet_wise_user_app/domain/entities/category_draft.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/domain/repositories/category_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';
import 'package:fleet_wise_user_app/domain/tasks/categories/load_categories_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/save_expense_task.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/add_expense_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/add_expense_view_model.dart';

import 'support/form_expenses.dart';
import 'support/memory_categories.dart';
import 'support/memory_user_preferences.dart';
import 'support/load_expense_fonts.dart';

const rent = TransactionCategory(
  id: 'rent',
  name: 'Rent',
  icon: CategoryIcon.home,
  color: CategoryColor.indigo,
  isIncome: false,
);
const consulting = TransactionCategory(
  id: 'consulting',
  name: 'Consulting',
  icon: CategoryIcon.work,
  color: CategoryColor.teal,
  isIncome: true,
);

Future<AddExpenseViewModel> form(
  MemoryCategories categories,
  FormExpenses expenses,
) async {
  final model = AddExpenseViewModel(
    createLoadCategoriesTask: () => LoadCategoriesTask(categories),
    createSaveAction: (row) =>
        ExpenseSaveAction(SaveExpenseTask(expenses, row)),
  );
  await model.loadCategories();
  return model;
}

void main() {
  setUpAll(loadExpenseFonts);
  test('custom expense and income retain independent selections and save the chosen income', () async {
    final categories = MemoryCategories()..rows.addAll([rent, consulting]);
    final expenses = FormExpenses();
    final model = await form(categories, expenses);
    addTearDown(model.dispose);
    model.selectCategory(rent);
    model.selectIncome(true);
    model.selectCategory(consulting);
    model.selectIncome(false);
    expect(model.selectedCategory!.id, rent.id);
    model.selectIncome(true);
    expect(model.selectedCategory!.id, consulting.id);
    expect(
      (await model.save(title: 'Client payment', amountMinor: 29)).status,
      ActionStatus.succeeded,
    );
    expect(expenses.rows.single.category.id, consulting.id);
    expect(expenses.rows.single.isIncome, isTrue);
  });

  test(
    'archived choices disappear on refresh and an empty type cannot save',
    () async {
      final categories = MemoryCategories();
      final model = await form(categories, FormExpenses());
      addTearDown(model.dispose);
      await categories.setArchived('default-food', true);
      await model.loadCategories();
      expect(model.selectedCategory, isNull);
      expect(model.canSave, isFalse);
      await expectLater(
        model.save(title: 'No category', amountMinor: 1),
        throwsStateError,
      );
      model.selectIncome(true);
      expect(model.canSave, isTrue);
    },
  );

  test('failed category reads block saving until retry succeeds', () async {
    final categories = MemoryCategories()..readError = StateError('storage');
    final model = await form(categories, FormExpenses());
    addTearDown(model.dispose);
    expect(model.canSave, isFalse);
    expect(model.contentState.hasError, isTrue);
    categories.readError = null;
    await model.loadCategories();
    expect(model.canSave, isTrue);
    categories.readError = StateError('storage');
    await model.loadCategories();
    expect(model.contentState.hasData, isTrue);
    expect(model.canSave, isFalse);
  });

  test('stale-category failure is not replayed and refresh keeps the selected ID after a rename', () async {
    final categories = MemoryCategories()..rows.add(rent);
    final expenses = FormExpenses()
      ..saveError = const CategoryException(CategoryProblem.archived);
    final model = await form(categories, expenses);
    addTearDown(model.dispose);
    model.selectCategory(rent);
    expect(
      (await model.save(title: 'Rent', amountMinor: 29)).status,
      ActionStatus.failed,
    );
    await categories.saveCategory(
      const CategoryDraft(
        id: 'rent',
        name: 'Monthly rent',
        icon: CategoryIcon.bills,
        color: CategoryColor.teal,
        isIncome: false,
      ),
    );
    await model.loadCategories();
    expect(model.state.error, isNull);
    expect(model.selectedCategory!.id, rent.id);
    expect(model.selectedCategory!.name, 'Monthly rent');
    expect(expenses.rows, isEmpty);
  });

  group('application integration', () {
    setUp(() async {
      configureDependencies(getIt);
      await getIt.unregister<CategoryRepository>();
      getIt.registerSingleton<CategoryRepository>(
        MemoryCategories(allDefaults: true),
      );
      await getIt.unregister<ExpenseRepository>();
      getIt.registerSingleton<ExpenseRepository>(FormExpenses());
      await getIt.unregister<UserPreferencesRepository>();
      getIt.registerSingleton<UserPreferencesRepository>(
        MemoryUserPreferences(
          const UserPreferences(language: UserLanguage.english),
        ),
      );
    });
    tearDown(() => getIt.reset());

    Future<void> open(WidgetTester tester) async {
      await tester.pumpWidget(
        const ExpenseTrackerApp(initialLocation: '/expenses/add'),
      );
      await tester.pumpAndSettle();
    }

    Future<void> tap(WidgetTester tester, Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Future<void> fillTransaction(WidgetTester tester) async {
      await tester.enterText(find.byType(TextFormField).at(0), 'House bill');
      await tester.enterText(find.byType(TextFormField).at(1), '12.50');
    }

    testWidgets(
      'add category from transaction form, return with inputs intact and chart uses its name',
      (tester) async {
        await open(tester);
        await fillTransaction(tester);
        await tap(tester, find.text('Manage categories'));
        await tap(tester, find.byKey(const ValueKey('category-add')));
        await tester.enterText(
          find.byKey(const ValueKey('category-name')),
          'Rent',
        );
        await tap(tester, find.byKey(const ValueKey('category-icon-home')));
        await tap(tester, find.byKey(const ValueKey('category-color-indigo')));
        await tap(tester, find.byKey(const ValueKey('category-save')));
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(AddExpenseScreen), findsOneWidget);
        expect(find.text('House bill'), findsOneWidget);
        expect(find.text('12.50'), findsOneWidget);
        await tap(tester, find.widgetWithText(ChoiceChip, 'Rent'));
        await tap(tester, find.text('Save Transaction'));
        final saved = (getIt<ExpenseRepository>() as FormExpenses).rows.single;
        expect(saved.category.name, 'Rent');
        expect(saved.category.icon, CategoryIcon.home);
        expect(saved.category.color, CategoryColor.indigo);
        expect(find.text('Rent: 100.0%'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'archive the selected category from manager and return without losing form data',
      (tester) async {
        (getIt<CategoryRepository>() as MemoryCategories).rows.add(rent);
        await open(tester);
        await fillTransaction(tester);
        await tap(tester, find.widgetWithText(ChoiceChip, 'Rent'));
        expect(
          tester
              .element(find.byType(AddExpenseScreen))
              .read<AddExpenseViewModel>()
              .selectedCategory!
              .id,
          'rent',
        );
        await tap(tester, find.text('Manage categories'));
        await tap(
          tester,
          find.descendant(
            of: find.byKey(const ValueKey('rent')),
            matching: find.text('Archive'),
          ),
        );
        await tap(tester, find.widgetWithText(FilledButton, 'Archive'));
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        final model = tester
            .element(find.byType(AddExpenseScreen))
            .read<AddExpenseViewModel>();
        expect(model.selectedCategory, isNull);
        expect(model.canSave, isFalse);
        expect(
          model.availableCategories.any((category) => category.id == rent.id),
          isFalse,
        );
        expect(find.text('House bill'), findsOneWidget);
        expect(
          find.text('Choose an active category to continue.'),
          findsOneWidget,
        );
        await tap(
          tester,
          find.byKey(const ValueKey('expense-category-default-food')),
        );
        await tap(tester, find.text('Save Transaction'));
        expect(
          (getIt<ExpenseRepository>() as FormExpenses).rows.single.category.id,
          'default-food',
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'translated duplicate default/custom names stay distinct in the picker',
      (tester) async {
        const custom = TransactionCategory(
          id: 'custom-shopping',
          name: 'কেনাকাটা',
          icon: CategoryIcon.shopping,
          color: CategoryColor.teal,
          isIncome: false,
        );
        (getIt<CategoryRepository>() as MemoryCategories).rows.add(custom);
        await getIt<UserPreferencesRepository>().save(const UserPreferences());
        await open(tester);
        await fillTransaction(tester);
        expect(find.text('কেনাকাটা (পূর্বনির্ধারিত)'), findsOneWidget);
        expect(find.text('কেনাকাটা (নিজস্ব)'), findsOneWidget);
        await tap(
          tester,
          find.byKey(const ValueKey('expense-category-custom-shopping')),
        );
        await tap(tester, find.text('লেনদেন সংরক্ষণ করুন'));
        expect(
          (getIt<ExpenseRepository>() as FormExpenses).rows.single.category.id,
          custom.id,
        );
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets('long custom category names wrap at 320px and 2x text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(
        tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
      );
      const category = TransactionCategory(
        id: 'long',
        name: 'Monthly apartment rent and regular household bills',
        icon: CategoryIcon.home,
        color: CategoryColor.teal,
        isIncome: false,
      );
      (getIt<CategoryRepository>() as MemoryCategories).rows.add(category);
      await open(tester);
      await fillTransaction(tester);
      await tester.ensureVisible(
        find.byKey(const ValueKey('expense-category-long')),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .renderObject<RenderParagraph>(find.text(category.name))
            .didExceedMaxLines,
        isFalse,
      );
      await tap(tester, find.byKey(const ValueKey('expense-category-long')));
      await tap(tester, find.text('Save Transaction'));
      expect(
        (getIt<ExpenseRepository>() as FormExpenses).rows.single.category.id,
        category.id,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
      'empty categories offer management and disable save until a category exists',
      (tester) async {
        (getIt<CategoryRepository>() as MemoryCategories).rows.clear();
        await open(tester);
        await fillTransaction(tester);
        expect(
          find.text(
            'No active categories for this transaction type. Add or restore a category to continue.',
          ),
          findsOneWidget,
        );
        expect(
          tester
              .widget<ElevatedButton>(
                find.widgetWithText(ElevatedButton, 'Save Transaction'),
              )
              .onPressed,
          isNull,
        );
        await tap(tester, find.text('Manage categories'));
        await tap(tester, find.byKey(const ValueKey('category-add')));
        await tester.enterText(
          find.byKey(const ValueKey('category-name')),
          'Groceries',
        );
        await tap(tester, find.byKey(const ValueKey('category-save')));
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.text('House bill'), findsOneWidget);
        await tap(tester, find.text('Save Transaction'));
        expect(
          (getIt<ExpenseRepository>() as FormExpenses)
              .rows
              .single
              .category
              .name,
          'Groceries',
        );
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  });
}
