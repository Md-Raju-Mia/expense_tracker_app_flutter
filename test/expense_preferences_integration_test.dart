import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:fleet_wise_user_app/domain/entities/user_country.dart';
import 'package:fleet_wise_user_app/domain/entities/user_currency.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';
import 'package:fleet_wise_user_app/ui/expense/screens/expense_home_screen.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';
import 'package:fleet_wise_user_app/ui/preferences/view_models/user_preferences_view_model.dart';

import 'support/form_expenses.dart';
import 'support/load_expense_fonts.dart';

const englishUsd = UserPreferences(
  country: UserCountry.unitedStates,
  currency: UserCurrency.usd,
  language: UserLanguage.english,
);

Future<void> showApp(WidgetTester tester) async {
  await tester.pumpWidget(const ExpenseTrackerApp());
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadExpenseFonts);
  late FormExpenses expenses;
  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    configureDependencies(getIt);
    expenses = FormExpenses();
    await getIt.unregister<ExpenseRepository>();
    getIt.registerSingleton<ExpenseRepository>(expenses);
  });
  tearDown(() async {
    await getIt.reset();
    SharedPreferencesAsyncPlatform.instance = null;
  });

  testWidgets('fresh preferences select Bengali and save a BDT transaction', (
    tester,
  ) async {
    await showApp(tester);
    expect(find.text('আয় ব্যয়ের হিসাব'), findsOneWidget);
    await tester.tap(find.text('লেনদেন যোগ করুন'));
    await tester.pumpAndSettle();
    expect(find.text('পরিমাণ (BDT)'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
    await tester.enterText(find.byType(TextFormField).at(1), '২৫.৫০');
    await tester.ensureVisible(find.text('লেনদেন সংরক্ষণ করুন'));
    await tester.tap(find.text('লেনদেন সংরক্ষণ করুন'));
    await tester.pumpAndSettle();
    expect(expenses.rows.single.currencyCode, 'BDT');
    expect(expenses.rows.single.amountMinor, 2550);
    final home = tester
        .element(find.byType(ExpenseHomeScreen))
        .read<ExpenseHomeViewModel>();
    expect(home.contentState.data!.currencyCode, 'BDT');
    expect(home.contentState.data!.totalExpenseMinor, BigInt.from(2550));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'saved settings apply language/currency without relabeling existing records and survive restart',
    (tester) async {
      final preferences = getIt<UserPreferencesRepository>();
      await preferences.save(englishUsd);
      expenses.rows.addAll([
        Expense(
          id: 1,
          title: 'Old dollars',
          amountMinor: 1200,
          date: DateTime(2026, 4, 9),
          category: ExpenseCategory.food,
        ),
        Expense(
          id: 2,
          title: 'Taka',
          amountMinor: 10000,
          date: DateTime(2026, 4, 10),
          category: ExpenseCategory.shopping,
          currencyCode: 'BDT',
        ),
      ]);
      await showApp(tester);
      final home = tester
          .element(find.byType(ExpenseHomeScreen))
          .read<ExpenseHomeViewModel>();
      expect(home.contentState.data!.totalExpenseMinor, BigInt.from(1200));
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<UserCountry>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bangladesh').last);
      await tester.pumpAndSettle();
      // Draft changes do not affect the current dashboard yet.
      expect(home.contentState.data!.currencyCode, 'USD');
      await tester.ensureVisible(find.text('পছন্দ সংরক্ষণ করুন'));
      await tester.tap(find.text('পছন্দ সংরক্ষণ করুন'));
      await tester.pumpAndSettle();
      expect(find.text('আয় ব্যয়ের হিসাব'), findsOneWidget);
      expect(home.contentState.data!.currencyCode, 'BDT');
      expect(home.contentState.data!.totalExpenseMinor, BigInt.from(10000));
      expect(
        home.expenses.firstWhere((row) => row.id == 1).currencyCode,
        'USD',
      );
      expect(home.expenses.firstWhere((row) => row.id == 1).amountMinor, 1200);
      await tester.scrollUntilVisible(find.text('USD'), 240);
      expect(find.text('USD'), findsOneWidget);
      final saved = await preferences.load();
      expect(saved.currency, UserCurrency.bdt);
      expect(saved.language, UserLanguage.bengali);
      await tester.pumpWidget(const SizedBox.shrink());
      await showApp(tester);
      expect(find.text('আয় ব্যয়ের হিসাব'), findsOneWidget);
      final reopenedHome = tester
          .element(find.byType(ExpenseHomeScreen))
          .read<ExpenseHomeViewModel>();
      expect(
        reopenedHome.contentState.data!.totalExpenseMinor,
        BigInt.from(10000),
      );
      expect(reopenedHome.contentState.data!.currencyCode, 'BDT');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('back discards an unsaved settings draft', (tester) async {
    await getIt<UserPreferencesRepository>().save(englishUsd);
    await showApp(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<UserCountry>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('India').last);
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    final homeContext = tester.element(find.byType(ExpenseHomeScreen));
    final model = homeContext.read<UserPreferencesViewModel>();
    expect(model.savedPreferences!.country, UserCountry.unitedStates);
    expect(model.draft.country, UserCountry.unitedStates);
    expect(find.text('Expense Tracker'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'Bengali dashboard with mixed currencies supports 320px and 2x text',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(
        tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
      );
      expenses.rows.add(
        Expense(
          id: 1,
          title: 'খাবার',
          amountMinor: 10000,
          date: DateTime(2026, 4, 9),
          category: ExpenseCategory.food,
          currencyCode: 'BDT',
        ),
      );
      await showApp(tester);
      await tester.scrollUntilVisible(find.text('BDT'), 200);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('লেনদেন যোগ করুন'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('লেনদেন সংরক্ষণ করুন'));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
