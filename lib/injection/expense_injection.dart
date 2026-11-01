import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../data/datasources/local/expense_local_data_source.dart';
import '../data/repositories/expense_repository_impl.dart';
import '../domain/actions/expense_delete_action.dart';
import '../domain/actions/expense_save_action.dart';
import '../domain/actions/expense_update_action.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';
import '../domain/tasks/expense/delete_expense_task.dart';
import '../domain/tasks/expense/load_expenses_task.dart';
import '../domain/tasks/expense/save_expense_task.dart';
import '../domain/tasks/expense/load_expense_form_task.dart';
import '../domain/tasks/expense/update_expense_task.dart';
import '../domain/repositories/category_repository.dart';
import '../ui/expense/view_models/expense_form_view_model.dart';
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
  container.registerFactoryParam<UpdateExpenseTask, Expense, void>(
    (expense, _) => UpdateExpenseTask(container<ExpenseRepository>(), expense),
  );
  container.registerFactoryParam<ExpenseUpdateAction, Expense, void>(
    (expense, _) =>
        ExpenseUpdateAction(container<UpdateExpenseTask>(param1: expense)),
  );
  container.registerFactoryParam<LoadExpenseFormTask, int?, void>(
    (id, _) => LoadExpenseFormTask(
      container<ExpenseRepository>(),
      container<CategoryRepository>(),
      transactionId: id,
    ),
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
  container.registerFactoryParam<ExpenseFormViewModel, int?, String?>(
    (id, currencyCode) => ExpenseFormViewModel(
      transactionId: id,
      currencyCode: currencyCode ?? 'USD',
      createLoadTask: () => container<LoadExpenseFormTask>(param1: id),
      createUpdateAction: (expense) =>
          container<ExpenseUpdateAction>(param1: expense),
      createSaveAction: (expense) =>
          container<ExpenseSaveAction>(param1: expense),
    ),
  );
}
