import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/add_expense_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_home_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/add_expense_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/widgets/expense_category_picker.dart';

import 'support/load_expense_fonts.dart';

class FormExpenses implements ExpenseRepository {
  final rows = <Expense>[];
  Completer<int>? pendingSave;
  Object? saveError;
  @override
  Future<List<Expense>> getExpenses() async => List.of(rows.reversed);
  @override
  Future<int> insertExpense(Expense expense) async {
    if (saveError != null) throw saveError!;
    final id = pendingSave == null
        ? rows.length + 1
        : await pendingSave!.future;
    rows.add(
      Expense(
        id: id,
        title: expense.title,
        amount: expense.amount,
        date: expense.date,
        category: expense.category,
        isIncome: expense.isIncome,
      ),
    );
    return id;
  }

  @override
  Future<int> deleteExpense(int id) async {
    rows.removeWhere((row) => row.id == id);
    return 1;
  }
}

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
    repository = FormExpenses();
    await getIt.unregister<ExpenseRepository>();
    getIt.registerSingleton<ExpenseRepository>(repository);
  });
  tearDown(() => getIt.reset());

  testWidgets('startup home, validation, immediate pop, save and home reload', (
    tester,
  ) async {
    await openApp(tester);
    expect(find.byType(ExpenseHomeScreen), findsOneWidget);
    final home = tester
        .element(find.byType(ExpenseHomeScreen))
        .read<ExpenseHomeViewModel>();
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();
    await tapSave(tester);
    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Enter a valid amount'), findsOneWidget);
    expect(repository.rows, isEmpty);
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
    await tester.enterText(find.byType(TextFormField).at(1), '12.5');
    repository.pendingSave = Completer<int>();
    final form = tester
        .element(find.byType(AddExpenseScreen))
        .read<AddExpenseViewModel>();
    await tapSave(tester);
    expect(find.byType(AddExpenseScreen), findsNothing);
    expect(repository.rows, isEmpty);
    expect(form.isDisposed, isTrue);
    repository.pendingSave!.complete(1);
    await tester.pumpAndSettle();
    expect(
      tester
          .element(find.byType(ExpenseHomeScreen))
          .read<ExpenseHomeViewModel>(),
      same(home),
    );
    expect(home.expenses.single.title, 'Lunch');
    expect(repository.rows.single.category, ExpenseCategory.food);
    expect(repository.rows.single.amount, 12.5);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(home.isDisposed, isTrue);
  });

  testWidgets(
    'form toggle retains fields and category; income forces income category',
    (tester) async {
      await openApp(tester, initialLocation: '/expenses/add');
      await tester.enterText(find.byType(TextFormField).at(0), 'Salary');
      await tester.enterText(find.byType(TextFormField).at(1), '100');
      await tester.tap(find.text('SHOPPING'));
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      expect(find.byType(ExpenseCategoryPicker), findsNothing);
      await tester.tap(find.text('Expense'));
      await tester.pumpAndSettle();
      final form = tester
          .element(find.byType(AddExpenseScreen))
          .read<AddExpenseViewModel>();
      expect(form.selectedCategory, ExpenseCategory.shopping);
      expect(find.text('Salary'), findsOneWidget);
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      await tapSave(tester);
      expect(repository.rows.single.isIncome, isTrue);
      expect(repository.rows.single.category, ExpenseCategory.income);
      final home = tester
          .element(find.byType(ExpenseHomeScreen))
          .read<ExpenseHomeViewModel>();
      expect(home.contentState.data!.totalIncome, 100);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('whitespace title and negative amount remain accepted', (
    tester,
  ) async {
    await openApp(tester, initialLocation: '/expenses/add');
    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.enterText(find.byType(TextFormField).at(1), '-5');
    // Income avoids asking the chart library to draw negative expense sections.
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();
    await tapSave(tester);
    expect(repository.rows.single.title, '   ');
    expect(repository.rows.single.amount, -5);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'date picker range, cancellation, selection and back without saving',
    (tester) async {
      await openApp(tester, initialLocation: '/expenses/add');
      final model = tester
          .element(find.byType(AddExpenseScreen))
          .read<AddExpenseViewModel>();
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

  testWidgets('failed save returns home without adding a transaction', (
    tester,
  ) async {
    repository.saveError = StateError('disk full');
    await openApp(tester, initialLocation: '/expenses/add');
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
    await tester.enterText(find.byType(TextFormField).at(1), '10');
    await tapSave(tester);
    expect(find.byType(ExpenseHomeScreen), findsOneWidget);
    expect(repository.rows, isEmpty);
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
