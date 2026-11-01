import 'support/test_categories.dart';

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'support/load_expense_fonts.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_delete_action.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/delete_expense_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/load_expenses_task.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_home_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';

class MemoryExpenses implements ExpenseRepository {
  MemoryExpenses(this.rows);
  final List<Expense> rows;
  int deletes = 0;
  Object? readError;
  @override
  Future<List<Expense>> getExpenses() async {
    if (readError != null) throw readError!;
    return List.of(rows);
  }

  @override
  Future<int> insertExpense(Expense expense) async =>
      throw UnimplementedError();
  @override
  Future<int> deleteExpense(int id) async {
    deletes++;
    rows.removeWhere((row) => row.id == id);
    return 1;
  }
}

Expense row(
  int id,
  double amount,
  TransactionCategory category, {
  bool income = false,
}) => Expense(
  id: id,
  title: category.name,
  amountMinor: (amount * 100).round(),
  date: DateTime(2026, 4, 9, 12, 30 - id),
  category: category,
  isIncome: income,
);

Future<void> showHome(
  WidgetTester tester,
  MemoryExpenses repository, {
  VoidCallback? onAdd,
  String language = 'en',
}) async {
  final model = ExpenseHomeViewModel(
    createLoadTask: (currencyCode) =>
        LoadExpensesTask(repository, currencyCode: currencyCode),
    createDeleteAction: (id) =>
        ExpenseDeleteAction(DeleteExpenseTask(repository, id)),
  );
  await model.initialize();
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      theme: ThemeData.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: RepaintBoundary(
        key: const ValueKey('home-preview'),
        child: ChangeNotifierProvider(
          create: (_) => model,
          child: ExpenseHomeScreen(onAddTransaction: onAdd ?? () {}),
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
    'empty home preserves English light appearance and Add callback',
    (tester) async {
      var adds = 0;
      await showHome(tester, MemoryExpenses([]), onAdd: () => adds++);
      expect(find.text('No transactions yet!'), findsOneWidget);
      expect(find.text('Total Balance'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      final context = tester.element(find.text('Expense Tracker'));
      expect(Theme.of(context).brightness, Brightness.light);
      await tester.tap(find.text('Add Transaction'));
      expect(adds, 1);
    },
  );

  testWidgets('reference home renders original totals chart and legend', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await showHome(
      tester,
      MemoryExpenses([
        row(1, 1000, TestCategories.others),
        row(2, 2000, TestCategories.health),
        row(3, 3000, TestCategories.transport),
        row(4, 6000, TestCategories.shopping),
        row(5, 5000, TestCategories.food),
        row(6, 30000, TestCategories.income, income: true),
      ]),
    );
    expect(find.text(r'$13000.00'), findsOneWidget);
    expect(find.text(r'$30000.00'), findsOneWidget);
    expect(find.text(r'$17000.00'), findsNWidgets(2));
    expect(find.text('Others: 5.9%'), findsOneWidget);
    expect(find.text('Food: 29.4%'), findsOneWidget);
    expect(tester.takeException(), isNull);
    if (const bool.fromEnvironment('SAVE_EXPENSE_PREVIEW')) {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('home-preview')),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await Directory('build').create(recursive: true);
        await File('build/expense_home_preview.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });

  testWidgets(
    'same translated names use separate default/custom chart labels',
    (tester) async {
      const custom = TransactionCategory(
        id: 'custom-shopping',
        name: 'কেনাকাটা',
        icon: CategoryIcon.shopping,
        color: CategoryColor.teal,
        isIncome: false,
      );
      await showHome(
        tester,
        MemoryExpenses([
          row(1, .1, TestCategories.shopping),
          row(2, .2, custom),
        ]),
        language: 'bn',
      );
      expect(find.text('কেনাকাটা (পূর্বনির্ধারিত): ৩৩.৩%'), findsOneWidget);
      expect(find.text('কেনাকাটা (নিজস্ব): ৬৬.৭%'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'failed initial category/transaction read offers retry instead of an empty balance',
    (tester) async {
      final repository = MemoryExpenses([row(1, .29, TestCategories.food)])
        ..readError = StateError('migration');
      await showHome(tester, repository);
      expect(
        find.text('Could not load transactions. Try again.'),
        findsOneWidget,
      );
      expect(find.text(r'$0.00'), findsNothing);
      repository.readError = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text(r'$-0.29'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('archived custom categories remain in chart and history', (
    tester,
  ) async {
    const category = TransactionCategory(
      id: 'archived-travel',
      name: 'Travel',
      icon: CategoryIcon.transport,
      color: CategoryColor.blue,
      isIncome: false,
      isArchived: true,
    );
    await showHome(tester, MemoryExpenses([row(1, .29, category)]));
    expect(find.text('Travel (archived): 100.0%'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Travel (archived)'), 200);
    expect(find.text('Travel (archived)'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('income-only list keeps See All inert and confirms deletion', (
    tester,
  ) async {
    final repository = MemoryExpenses([
      row(1, 30, TestCategories.income, income: true),
    ]);
    await showHome(tester, repository);
    expect(find.text('Spent'), findsNothing);
    expect(find.text('Spending Analysis'), findsOneWidget);
    expect(find.text(r'+$30.00'), findsOneWidget);
    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();
    expect(find.byType(ExpenseHomeScreen), findsOneWidget);
    await tester.ensureVisible(find.byIcon(Icons.delete_outline));
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Delete Transaction'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repository.deletes, 0);
    await tester.ensureVisible(find.byIcon(Icons.delete_outline));
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(repository.deletes, 1);
    expect(find.text('No transactions yet!'), findsOneWidget);
  });
}
