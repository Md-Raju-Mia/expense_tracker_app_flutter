import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fleet_wise_user_app/main.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/domain/repositories/category_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/repositories/user_preferences_repository.dart';
import 'package:fleet_wise_user_app/ui/categories/screens/categories_screen.dart';
import 'package:fleet_wise_user_app/ui/categories/view_models/categories_view_model.dart';

import 'support/form_expenses.dart';
import 'support/memory_categories.dart';
import 'support/memory_user_preferences.dart';
import 'support/load_expense_fonts.dart';

void main() {
  setUpAll(loadExpenseFonts);
  setUp(() async {
    configureDependencies(getIt);
    await getIt.unregister<CategoryRepository>();
    getIt.registerSingleton<CategoryRepository>(MemoryCategories());
    await getIt.unregister<ExpenseRepository>();
    getIt.registerSingleton<ExpenseRepository>(FormExpenses());
    await getIt.unregister<UserPreferencesRepository>();
    getIt.registerSingleton<UserPreferencesRepository>(MemoryUserPreferences());
  });
  tearDown(() => getIt.reset());
  testWidgets(
    'home opens localized management; Back disposes draft and reopening creates fresh state',
    (tester) async {
      await tester.pumpWidget(const ExpenseTrackerApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.category_outlined));
      await tester.pumpAndSettle();
      expect(find.text('বিভাগ পরিচালনা'), findsOneWidget);
      final first = tester
          .element(find.byType(CategoriesScreen))
          .read<CategoriesViewModel>();
      await tester.tap(find.byKey(const ValueKey('category-add')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('category-name')),
        'Unsaved',
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(first.isDisposed, isTrue);
      await tester.tap(find.byIcon(Icons.category_outlined));
      await tester.pumpAndSettle();
      final reopened = tester
          .element(find.byType(CategoriesScreen))
          .read<CategoriesViewModel>();
      expect(reopened, isNot(same(first)));
      expect(reopened.editing, isFalse);
      expect(find.text('খাবার'), findsOneWidget);
      expect((getIt<CategoryRepository>() as MemoryCategories).writes, 0);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('direct categories link loads its route-owned model', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ExpenseTrackerApp(initialLocation: '/expenses/categories'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesScreen), findsOneWidget);
    expect(find.text('খাবার'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
