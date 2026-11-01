import 'expense.dart';
import 'transaction_category.dart';

class ExpenseFormData {
  ExpenseFormData({required List<TransactionCategory> categories, this.expense})
    : categories = List.unmodifiable(categories);

  final List<TransactionCategory> categories;
  final Expense? expense;
}
