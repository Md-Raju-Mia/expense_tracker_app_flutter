import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_history_filter.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/category_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/load_expense_history_task.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_history_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_history_screen.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/l10n/l10n.dart';

import 'support/form_expenses.dart';
import 'support/test_categories.dart';
import 'support/memory_categories.dart';
import 'support/memory_user_preferences.dart';
import 'support/load_expense_fonts.dart';

Expense row(int id, DateTime date, {String currency = 'BDT'}) => Expense(
  id: id,
  syncId: 'history-$id',
  title: 'Entry $id',
  amountMinor: 29,
  date: date,
  currencyCode: currency,
  category: TestCategories.food,
);

class HistoryExpenses extends FormExpenses {
  Object? readError;
  Completer<List<Expense>>? pending;
  int reads = 0;
  @override
  Future<List<Expense>> getExpenses() async {
    reads++;
    if (readError != null) throw readError!;
    if (pending != null) return pending!.future;
    return super.getExpenses();
  }
}

void main() {
  setUpAll(loadExpenseFonts);
  test('calendar filters include whole day/month/year and exclude adjacent boundaries', () {
    final dates = [
      DateTime(2023, 12, 31, 23, 59),
      DateTime(2024, 2, 1),
      DateTime(2024, 2, 29, 23, 59, 59),
      DateTime(2024, 3, 1),
      DateTime(2025, 1, 1),
    ];
    final rows = [for (var i = 0; i < dates.length; i++) row(i, dates[i])];
    List<int?> ids(ExpenseHistoryPeriod period) => rows
        .where(
          ExpenseHistoryFilter(
            period: period,
            date: DateTime(2024, 2, 29),
          ).matches,
        )
        .map((e) => e.id)
        .toList();
    expect(ids(ExpenseHistoryPeriod.all), [0, 1, 2, 3, 4]);
    expect(ids(ExpenseHistoryPeriod.day), [2]);
    expect(ids(ExpenseHistoryPeriod.month), [1, 2]);
    expect(ids(ExpenseHistoryPeriod.year), [1, 2, 3]);
  });
  test('load sorts newest first with stable ID tie-break and does not mix currencies', () async {
    final repo = HistoryExpenses()
      ..rows.addAll([
        row(1, DateTime(2024)),
        row(2, DateTime(2025), currency: 'USD'),
        row(3, DateTime(2025)),
      ]);
    final model = ExpenseHistoryViewModel(
      createLoadTask: () => LoadExpenseHistoryTask(repo),
      today: DateTime(2025),
    );
    addTearDown(model.dispose);
    await model.load();
    expect(model.visibleExpenses.map((e) => e.id), [3, 2, 1]);
    model.selectPeriod(ExpenseHistoryPeriod.year);
    expect(model.visibleExpenses.map((e) => e.currencyCode), ['BDT', 'USD']);
    model.selectDate(DateTime(2024));
    expect(model.visibleExpenses.single.id, 1);
    expect(repo.reads, 1);
  });
  test('refresh retains filters/data on error, retry reloads edits, overlap/disposal are safe', () async {
    final repo = HistoryExpenses()..rows.add(row(1, DateTime(2024)));
    final model = ExpenseHistoryViewModel(
      createLoadTask: () => LoadExpenseHistoryTask(repo),
      today: DateTime(2024),
    );
    await model.load();
    model.selectPeriod(ExpenseHistoryPeriod.year);
    repo.readError = StateError('offline');
    await model.load();
    expect(model.contentState.hasError, isTrue);
    expect(model.visibleExpenses.length, 1);
    repo.readError = null;
    repo.rows.clear();
    await model.load();
    expect(model.visibleExpenses, isEmpty);
    expect(model.period, ExpenseHistoryPeriod.year);
    repo.pending = Completer<List<Expense>>();
    final pending = model.load();
    await model.load();
    expect(repo.reads, 4);
    model.dispose();
    repo.pending!.complete([row(2, DateTime(2024))]);
    await pending;
    expect(model.contentState.data, isNull);
  });

  group('routes', () {
    late HistoryExpenses repo;
    setUp(() async {
      configureDependencies(getIt);
      repo = HistoryExpenses()..rows.add(row(1, DateTime(2024, 2, 29)));
      await getIt.unregister<ExpenseRepository>();
      getIt.registerSingleton<ExpenseRepository>(repo);
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
    Future<void> tap(WidgetTester tester, Finder finder) async {
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    testWidgets(
      'Home history entry opens filters; edit returns refreshed history preserving filter',
      (tester) async {
        await tester.pumpWidget(const ExpenseTrackerApp());
        await tester.pumpAndSettle();
        await tap(tester, find.byTooltip('Transaction history'));
        await tap(tester, find.byKey(const ValueKey('history-period-year')));
        await tap(tester, find.byType(DropdownButtonFormField<int>));
        await tap(tester, find.text('2024').last);
        expect(find.text('Entry 1'), findsOneWidget);
        await tap(tester, find.byTooltip('Edit transaction'));
        await tester.enterText(
          find.byType(TextFormField).first,
          'Updated history',
        );
        await tap(tester, find.text('Save changes'));
        expect(find.text('Updated history'), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
        expect(repo.rows.single.id, 1);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
    testWidgets(
      'direct link error retries and empty period can reset to all time',
      (tester) async {
        repo.readError = StateError('read');
        await tester.pumpWidget(
          const ExpenseTrackerApp(initialLocation: '/expenses/history'),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('Could not load transactions. Try again.'),
          findsOneWidget,
        );
        repo.readError = null;
        await tap(tester, find.widgetWithText(FilledButton, 'Try again'));
        await tap(tester, find.byKey(const ValueKey('history-period-day')));
        expect(find.text('No transactions in this period.'), findsOneWidget);
        await tap(tester, find.byKey(const ValueKey('history-period-all')));
        expect(find.text('Entry 1'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  });
  for (final bn in [false, true]) {
    testWidgets(
      'history 320px 2x text Bengali=$bn, month/year/day controls and preview',
      (tester) async {
        tester.view.physicalSize = const Size(320, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(
          tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
        );
        final repo = HistoryExpenses()..rows.add(row(1, DateTime(2024, 2, 29)));
        final model = ExpenseHistoryViewModel(
          createLoadTask: () => LoadExpenseHistoryTask(repo),
          today: DateTime(2024, 2, 29),
        );
        addTearDown(model.dispose);
        await model.load();
        model.selectPeriod(ExpenseHistoryPeriod.month);
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: model,
            child: MaterialApp(
              locale: Locale(bn ? 'bn' : 'en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const RepaintBoundary(
                key: ValueKey('history-preview'),
                child: ExpenseHistoryScreen(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (const bool.fromEnvironment('SAVE_HISTORY_PREVIEW') && !bn) {
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(const ValueKey('history-preview')),
          );
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await File('build/history-preview.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
        model.selectPeriod(ExpenseHistoryPeriod.day);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        model.selectPeriod(ExpenseHistoryPeriod.year);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
