import '../../../core/base/content_view_model.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_history_filter.dart';
import '../../../domain/tasks/expense/load_expense_history_task.dart';

class ExpenseHistoryViewModel extends ContentViewModel<List<Expense>> {
  ExpenseHistoryViewModel({required this.createLoadTask, DateTime? today})
    : _date = today ?? DateTime.now();

  final LoadExpenseHistoryTask Function() createLoadTask;
  ExpenseHistoryPeriod _period = ExpenseHistoryPeriod.all;
  DateTime _date;

  ExpenseHistoryPeriod get period => _period;
  DateTime get date => _date;
  List<Expense> get allExpenses => contentState.data ?? const [];
  List<Expense> get visibleExpenses {
    final filter = ExpenseHistoryFilter(period: period, date: date);
    return allExpenses.where(filter.matches).toList();
  }

  List<int> get years {
    final values = {
      DateTime.now().year,
      date.year,
      ...allExpenses.map((row) => row.date.year),
    }.toList();
    values.sort((a, b) => b.compareTo(a));
    return values;
  }

  @override
  bool isEmptyResult(List<Expense> data) => data.isEmpty;

  Future<void> load() async {
    if (isDisposed || isFetching) return;
    await loadContent(createLoadTask());
  }

  void selectPeriod(ExpenseHistoryPeriod value) {
    if (isDisposed) return;
    _period = value;
    notifyListeners();
  }

  void selectDate(DateTime value) {
    if (isDisposed) return;
    _date = value;
    notifyListeners();
  }
}
