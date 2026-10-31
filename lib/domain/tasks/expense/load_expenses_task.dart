import '../../../core/base/base_task.dart';
import '../../entities/expense_summary.dart';
import '../../repositories/expense_repository.dart';

class LoadExpensesTask extends BaseTask<ExpenseSummary> {
  const LoadExpensesTask(this.repository, {this.currencyCode = 'USD'});

  final ExpenseRepository repository;
  final String currencyCode;

  @override
  String get name => 'Load expenses';

  @override
  Future<ExpenseSummary> run() async {
    final expenses = await repository.getExpenses();
    return ExpenseSummary(expenses, currencyCode: currencyCode);
  }
}
