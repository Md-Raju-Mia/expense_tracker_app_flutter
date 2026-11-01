import '../../../core/base/base_task.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

class LoadExpenseHistoryTask extends BaseTask<List<Expense>> {
  const LoadExpenseHistoryTask(this.repository);
  final ExpenseRepository repository;

  @override
  String get name => 'Load transaction history';

  @override
  Future<List<Expense>> run() async {
    final rows = List<Expense>.of(await repository.getExpenses());
    rows.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return List.unmodifiable(rows);
  }
}
