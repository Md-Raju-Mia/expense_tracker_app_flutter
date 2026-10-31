import 'dart:async';

import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/repositories/expense_repository.dart';

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
        currencyCode: expense.currencyCode,
        amountMinor: expense.amountMinor,
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
