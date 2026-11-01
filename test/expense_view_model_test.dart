import 'support/memory_categories.dart';

import 'package:fleet_wise_user_app/domain/tasks/categories/load_categories_task.dart';

import 'support/test_categories.dart';

import 'dart:async';

import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_delete_action.dart';
import 'package:fleet_wise_user_app/domain/actions/expense_save_action.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/delete_expense_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/load_expenses_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/save_expense_task.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/add_expense_view_model.dart';
import 'package:fleet_wise_user_app/ui/expense/view_models/expense_home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeExpenseRepository implements ExpenseRepository {
  List<Expense> rows = [];
  final calls = <String>[];
  Completer<int>? pendingSave;
  Completer<List<Expense>>? pendingRead;
  Object? saveError;
  Object? deleteError;
  Object? readError;

  @override
  Future<List<Expense>> getExpenses() async {
    calls.add('load');
    if (readError != null) throw readError!;
    if (pendingRead != null) {
      final read = pendingRead!;
      pendingRead = null;
      return read.future;
    }
    return List.of(rows);
  }

  @override
  Future<int> insertExpense(Expense expense) async {
    calls.add('save');
    if (saveError != null) throw saveError!;
    final id = pendingSave == null ? 1 : await pendingSave!.future;
    rows.add(expense);
    return id;
  }

  @override
  Future<int> deleteExpense(int id) async {
    calls.add('delete');
    if (deleteError != null) throw deleteError!;
    final count = rows.length;
    rows.removeWhere((expense) => expense.id == id);
    return count - rows.length;
  }
}

Expense expense({int? id}) => Expense(
  id: id,
  title: 'Lunch',
  amountMinor: 1200,
  date: DateTime(2026, 4, 9),
  category: TestCategories.food,
);

ExpenseHomeViewModel homeModel(FakeExpenseRepository repository) {
  return ExpenseHomeViewModel(
    createLoadTask: (currencyCode) =>
        LoadExpensesTask(repository, currencyCode: currencyCode),
    createDeleteAction: (id) =>
        ExpenseDeleteAction(DeleteExpenseTask(repository, id)),
  );
}

Future<AddExpenseViewModel> formModel(FakeExpenseRepository repository) async {
  final model = AddExpenseViewModel(
    createLoadCategoriesTask: () =>
        LoadCategoriesTask(MemoryCategories(allDefaults: true)),
    initialDate: DateTime(2026, 4, 9, 12, 30),
    createSaveAction: (expense) =>
        ExpenseSaveAction(SaveExpenseTask(repository, expense)),
  );
  await model.loadCategories();
  return model;
}

void main() {
  test('home loads totals and refreshes after successful deletion', () async {
    final repository = FakeExpenseRepository()..rows = [expense(id: 1)];
    final model = homeModel(repository);
    addTearDown(model.dispose);
    await model.initialize();
    expect(model.contentState.data!.balanceMinor, BigInt.from(-1200));
    await model.initialize();
    expect(repository.calls, ['load']);
    final result = await model.deleteExpense(1);
    expect(result.status, ActionStatus.succeeded);
    expect(repository.calls, ['load', 'delete', 'load']);
    expect(model.expenses, isEmpty);
  });

  test(
    'failed deletion retains data and original failure without reloading',
    () async {
      final failure = StateError('disk failure');
      final repository = FakeExpenseRepository()
        ..rows = [expense(id: 1)]
        ..deleteError = failure;
      final model = homeModel(repository);
      addTearDown(model.dispose);
      await model.initialize();
      final result = await model.deleteExpense(1);
      expect(result.error, same(failure));
      expect(result.failedTask, 'Delete expense');
      expect(model.expenses, hasLength(1));
      expect(repository.calls, ['load', 'delete']);
    },
  );

  test(
    'refresh after a write waits for an older read before reading fresh data',
    () async {
      final firstRead = Completer<List<Expense>>();
      final repository = FakeExpenseRepository()..pendingRead = firstRead;
      final model = homeModel(repository);
      addTearDown(model.dispose);
      final initial = model.initialize();
      await Future<void>.delayed(Duration.zero);
      repository.rows = [expense(id: 2)];
      final refresh = model.refresh();
      firstRead.complete([]);
      await Future.wait([initial, refresh]);
      expect(repository.calls, ['load', 'load']);
      expect(model.expenses.single.id, 2);
    },
  );

  test('failed refresh retains existing transactions', () async {
    final repository = FakeExpenseRepository()..rows = [expense(id: 1)];
    final model = homeModel(repository);
    addTearDown(model.dispose);
    await model.initialize();
    final failure = StateError('read failed');
    repository.readError = failure;
    await model.refresh();
    expect(model.contentState.error, same(failure));
    expect(model.expenses.single.id, 1);
  });

  test('form defaults and toggles retain category and selected date', () async {
    final repository = FakeExpenseRepository();
    final model = await formModel(repository);
    addTearDown(model.dispose);
    expect(model.isIncome, isFalse);
    expect(model.selectedCategory, TestCategories.food);
    expect(model.selectedDate, DateTime(2026, 4, 9, 12, 30));
    model.selectCategory(TestCategories.shopping);
    model.selectIncome(true);
    model.selectIncome(false);
    expect(model.selectedCategory, TestCategories.shopping);
    model.selectDate(DateTime(2026, 3, 1));
    await model.save(title: 'Lunch', amountMinor: 500);
    final saved = repository.rows.single;
    expect(saved.title, 'Lunch');
    expect(saved.amountMinor, 500);
    expect(saved.category, TestCategories.shopping);
    expect(saved.date, DateTime(2026, 3, 1));
  });

  test(
    'income uses income category without losing the expense selection',
    () async {
      final repository = FakeExpenseRepository();
      final model = await formModel(repository);
      addTearDown(model.dispose);
      model.selectCategory(TestCategories.health);
      model.selectIncome(true);
      await model.save(title: 'Salary', amountMinor: 10000);
      expect(repository.rows.single.category, TestCategories.income);
      expect(repository.rows.single.isIncome, isTrue);
      model.selectIncome(false);
      expect(model.selectedCategory, TestCategories.health);
    },
  );

  test(
    'accepted save finishes after form disposal and home can refresh',
    () async {
      final save = Completer<int>();
      final repository = FakeExpenseRepository()..pendingSave = save;
      final home = homeModel(repository);
      final form = await formModel(repository);
      addTearDown(home.dispose);
      await home.initialize();
      var notifications = 0;
      form.addListener(() => notifications++);
      final pending = form.save(title: 'Lunch', amountMinor: 1200);
      form.dispose();
      final beforeCompletion = notifications;
      save.complete(1);
      final outcome = await pending;
      // The future screen will capture the home model before popping the form.
      if (outcome.status == ActionStatus.succeeded) await home.refresh();
      expect(outcome.status, ActionStatus.succeeded);
      expect(home.expenses.single.title, 'Lunch');
      expect(notifications, beforeCompletion);
    },
  );

  test(
    'busy save rejects duplicates and failed save supports an explicit retry',
    () async {
      final repository = FakeExpenseRepository()
        ..pendingSave = Completer<int>();
      final model = await formModel(repository);
      addTearDown(model.dispose);
      final pending = model.save(title: 'One', amountMinor: 100);
      await expectLater(
        model.save(title: 'Two', amountMinor: 200),
        throwsStateError,
      );
      repository.pendingSave!.complete(1);
      await pending;
      expect(repository.rows, hasLength(1));
      final failure = StateError('cannot save');
      repository.saveError = failure;
      final failed = await model.save(title: 'Retry', amountMinor: 300);
      expect(failed.error, same(failure));
      expect(failed.failedTask, 'Save expense');
      repository.saveError = null;
      await model.save(title: 'Retry', amountMinor: 300);
      expect(repository.rows, hasLength(2));
    },
  );
  test('new writes reject invalid amounts and blank titles before repository access', () async {
    final repository = FakeExpenseRepository();
    final model = await formModel(repository);
    addTearDown(model.dispose);
    for (final amount in [0, -500, 1000000000000000]) {
      final outcome = await model.save(title: 'Lunch', amountMinor: amount);
      expect(outcome.status, ActionStatus.failed);
      expect(outcome.failedTask, 'Save expense');
    }
    final blank = await model.save(title: '   ', amountMinor: 1000);
    expect(blank.status, ActionStatus.failed);
    expect(repository.calls, isEmpty);
    expect(repository.rows, isEmpty);
    expect(
      (await model.save(title: 'Lunch', amountMinor: 29)).status,
      ActionStatus.succeeded,
    );
    expect(repository.rows.single.amountMinor, 29);
  });
}
