import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_save_action.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_category.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/add_expense_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test(
    'expense factories are independent and container closes the database',
    () async {
      sqfliteFfiInit();
      final container = GetIt.asNewInstance();
      configureDependencies(container);
      addTearDown(container.reset);
      await container.unregister<ExpenseLocalDataSource>();
      container.registerLazySingleton<ExpenseLocalDataSource>(
        () => ExpenseLocalDataSource(
          factory: databaseFactoryFfi,
          databasePath: inMemoryDatabasePath,
        ),
        dispose: (source) => source.close(),
      );
      final first = container<ExpenseHomeViewModel>();
      final second = container<ExpenseHomeViewModel>();
      final form = container<AddExpenseViewModel>();
      final secondForm = container<AddExpenseViewModel>();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      addTearDown(form.dispose);
      addTearDown(secondForm.dispose);
      expect(first, isNot(same(second)));
      expect(form, isNot(same(secondForm)));
      final expense = Expense(
        title: 'Food',
        amount: 10,
        date: DateTime(2026, 4, 9),
        category: ExpenseCategory.food,
      );
      final action = container<ExpenseSaveAction>(param1: expense);
      final nextAction = container<ExpenseSaveAction>(param1: expense);
      expect(action, isNot(same(nextAction)));
      expect(action.task, isNot(same(nextAction.task)));
      expect(action.task.repository, same(container<ExpenseRepository>()));
      await action.run();
      await first.initialize();
      expect(first.expenses.single.title, 'Food');
      final db = await container<ExpenseLocalDataSource>().database;
      await container.reset();
      expect(db.isOpen, isFalse);
    },
  );
}
