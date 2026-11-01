import '../../domain/entities/expense.dart';
import 'category_mapper.dart';
import '../models/expense_model.dart';

extension ExpenseModelMapper on ExpenseModel {
  Expense toEntity() {
    final savedCategory = categoryDetails;
    if (savedCategory == null) {
      throw const FormatException('Transaction category was not loaded');
    }
    return Expense(
      id: id,
      syncId: syncId,
      currencyCode: currencyCode,
      title: title,
      amountMinor: amountMinor,
      date: DateTime.parse(date),
      category: savedCategory.toEntity(),
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
      categoryId: category.id,
      isIncome: isIncome ? 1 : 0,
    );
  }
}
