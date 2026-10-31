import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../data/datasources/local/expense_local_data_source.dart';
import '../data/repositories/expense_repository_impl.dart';
import '../domain/actions/expense_delete_action.dart';
import '../domain/actions/expense_save_action.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';
import '../domain/tasks/expense/delete_expense_task.dart';
import '../domain/tasks/expense/load_expenses_task.dart';
import '../domain/tasks/expense/save_expense_task.dart';
import '../ui/expense/view_models/add_expense_view_model.dart';
import '../ui/expense/view_models/expense_home_view_model.dart';

void configureExpenseDependencies(GetIt container) {
  container.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSource(factory: databaseFactory),
    dispose: (source) => source.close(),
  );
  container.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(container<ExpenseLocalDataSource>()),
  );
  container.registerFactoryParam<LoadExpensesTask, String?, void>(
    (currencyCode, _) => LoadExpensesTask(
      container<ExpenseRepository>(),
      currencyCode: currencyCode ?? 'USD',
    ),
  );
  container.registerFactoryParam<SaveExpenseTask, Expense, void>(
    (expense, _) => SaveExpenseTask(container<ExpenseRepository>(), expense),
  );
  container.registerFactoryParam<DeleteExpenseTask, int, void>(
    (id, _) => DeleteExpenseTask(container<ExpenseRepository>(), id),
  );
  container.registerFactoryParam<ExpenseSaveAction, Expense, void>(
    (expense, _) =>
        ExpenseSaveAction(container<SaveExpenseTask>(param1: expense)),
  );
  container.registerFactoryParam<ExpenseDeleteAction, int, void>(
    (id, _) => ExpenseDeleteAction(container<DeleteExpenseTask>(param1: id)),
  );
  container.registerFactory<ExpenseHomeViewModel>(
    () => ExpenseHomeViewModel(
      createLoadTask: (currencyCode) =>
          container<LoadExpensesTask>(param1: currencyCode),
      createDeleteAction: (id) => container<ExpenseDeleteAction>(param1: id),
    ),
  );
  container.registerFactoryParam<AddExpenseViewModel, String?, void>(
    (currencyCode, _) => AddExpenseViewModel(
      currencyCode: currencyCode ?? 'USD',
      createSaveAction: (expense) =>
          container<ExpenseSaveAction>(param1: expense),
    ),
  );
}
