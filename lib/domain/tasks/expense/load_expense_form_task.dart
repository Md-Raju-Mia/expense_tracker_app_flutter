import '../../../core/base/base_task.dart';
import '../../entities/expense.dart';
import '../../entities/expense_exception.dart';
import '../../entities/expense_form_data.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/expense_repository.dart';

class LoadExpenseFormTask extends BaseTask<ExpenseFormData> {
  const LoadExpenseFormTask(
    this.expenses,
    this.categories, {
    this.transactionId,
  });
  final ExpenseRepository expenses;
  final CategoryRepository categories;
  final int? transactionId;

  @override
  String get name => 'Load transaction form';

  @override
  Future<ExpenseFormData> run() async {
    Expense? original;
    if (transactionId != null) {
      original = await expenses.getExpense(transactionId!);
      if (original == null) {
        throw const ExpenseException(ExpenseProblem.notFound);
      }
    }
    final choices = await categories.getCategories(
      includeArchived: transactionId != null,
    );
    return ExpenseFormData(categories: choices, expense: original);
  }
}
