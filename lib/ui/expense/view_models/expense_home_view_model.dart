import '../../../core/base/content_view_model.dart';
import '../../../core/state/action_state.dart';
import '../../../domain/actions/expense_delete_action.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_summary.dart';
import '../../../domain/tasks/expense/load_expenses_task.dart';

class ExpenseHomeViewModel extends ContentViewModel<ExpenseSummary> {
  ExpenseHomeViewModel({
    required this.createLoadTask,
    required this.createDeleteAction,
  });

  final LoadExpensesTask Function() createLoadTask;
  final ExpenseDeleteAction Function(int id) createDeleteAction;
  Future<void>? _pendingLoad;

  List<Expense> get expenses => contentState.data?.expenses ?? const [];

  @override
  bool isEmptyResult(ExpenseSummary data) => data.expenses.isEmpty;

  Future<void> initialize() async {
    if (isDisposed || contentState.hasData || isFetching) return;
    await refresh();
  }

  Future<void> refresh() {
    final pending = _refreshAfter(_pendingLoad);
    _pendingLoad = pending;
    return pending;
  }

  Future<void> _refreshAfter(Future<void>? previousLoad) async {
    // A write can finish during the initial read. Wait, then read fresh rows.
    await previousLoad;
    if (isDisposed) return;
    await loadContent(createLoadTask());
  }

  Future<ActionState> deleteExpense(int id) async {
    final outcome = await execute(createDeleteAction(id));
    if (outcome.status == ActionStatus.succeeded && !isDisposed) {
      await refresh();
    }
    return outcome;
  }
}
