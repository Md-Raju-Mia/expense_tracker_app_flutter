import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../models/expense_model.dart';

extension ExpenseModelMapper on ExpenseModel {
  Expense toEntity() {
    return Expense(
      id: id,
      syncId: syncId,
      currencyCode: currencyCode,
      title: title,
      amountMinor: amountMinor,
      date: DateTime.parse(date),
      category: ExpenseCategory.values[category],
      isIncome: isIncome == 1,
    );
  }
}

extension ExpenseMapper on Expense {
  ExpenseModel toModel() {
    return ExpenseModel(
      id: id,
      syncId: syncId,
      currencyCode: currencyCode,
      title: title,
      amountMinor: amountMinor,
      date: date.toIso8601String(),
      category: category.index,
      isIncome: isIncome ? 1 : 0,
    );
  }
}
