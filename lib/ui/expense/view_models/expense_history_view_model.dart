import '../../../core/base/content_view_model.dart';
import '../../../domain/actions/expense_history_export_action.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_history_filter.dart';
import '../../../domain/entities/expense_history_report.dart';
import '../../../domain/tasks/expense/load_expense_history_task.dart';

class ExpenseHistoryViewModel extends ContentViewModel<List<Expense>> {
  ExpenseHistoryViewModel({
    required this.createLoadTask,
    this.createExportAction,
    DateTime? today,
  }) : _date = today ?? DateTime.now();

  final LoadExpenseHistoryTask Function() createLoadTask;
  final ExpenseHistoryExportAction Function(ExpenseHistoryReport, bool)?
  createExportAction;
  ExpenseHistoryPeriod _period = ExpenseHistoryPeriod.all;
  DateTime _date;

  ExpenseHistoryPeriod get period => _period;
  DateTime get date => _date;
  List<Expense> get allExpenses => contentState.data ?? const [];
  List<Expense> get visibleExpenses {
    final filter = ExpenseHistoryFilter(period: period, date: date);
    return allExpenses.where(filter.matches).toList();
  }

  bool get supportsExport => createExportAction != null;
  bool get canExport =>
      supportsExport &&
      !isLoading &&
      !isFetching &&
      !contentState.hasError &&
      visibleExpenses.isNotEmpty;

  Future<bool> export(
    ExpenseHistoryReport report, {
    required bool share,
  }) async {
    if (isDisposed || !canExport) return false;
    final action = createExportAction!(report, share);
    await execute(action);
    return action.completed;
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
