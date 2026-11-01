import '../../../core/base/content_view_model.dart';
import '../../../core/state/action_state.dart';
import '../../../domain/actions/expense_save_action.dart';
import '../../../domain/actions/expense_update_action.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_form_data.dart';
import '../../../domain/entities/transaction_category.dart';
import '../../../domain/tasks/expense/load_expense_form_task.dart';

class ExpenseFormViewModel extends ContentViewModel<ExpenseFormData> {
  ExpenseFormViewModel({
    required this.createSaveAction,
    required this.createLoadTask,
    required this.createUpdateAction,
    this.transactionId,
    DateTime? initialDate,
    String currencyCode = 'USD',
  }) : _newCurrencyCode = currencyCode,
       _selectedDate = initialDate ?? DateTime.now();

  final ExpenseSaveAction Function(Expense expense) createSaveAction;
  final LoadExpenseFormTask Function() createLoadTask;
  final ExpenseUpdateAction Function(Expense expense) createUpdateAction;
  final int? transactionId;
  final String _newCurrencyCode;
  Expense? _original;
  bool _initialized = false;
  bool get isEditing => transactionId != null;
  String get currencyCode => _original?.currencyCode ?? _newCurrencyCode;
  String get initialTitle => _original?.title ?? '';
  int? get initialAmountMinor => _original?.amountMinor;
  DateTime _selectedDate;
  String? _expenseCategoryId;
  String? _incomeCategoryId;
  bool _isIncome = false;

  DateTime get selectedDate => _selectedDate;
  List<TransactionCategory> get availableCategories =>
      (contentState.data?.categories ?? [])
          .where(
            (category) =>
                (!category.isArchived && category.isIncome == isIncome) ||
                (_original != null &&
                    isIncome == _original!.isIncome &&
                    category.id == _original!.category.id),
          )
          .toList();
  TransactionCategory? get selectedCategory {
    final categories = availableCategories;
    if (categories.isEmpty) return null;
    final id = isIncome ? _incomeCategoryId : _expenseCategoryId;
    return categories.where((category) => category.id == id).firstOrNull;
  }

  bool get canSave =>
      !isDisposed &&
      !isLoading &&
      !isFetching &&
      !contentState.hasError &&
      selectedCategory != null;
  bool get isIncome => _isIncome;

  @override
  bool isEmptyResult(ExpenseFormData data) => false;

  Future<void> load() async {
    if (isDisposed || isLoading || isFetching) return;
    resetState();
    final outcome = await loadContent(createLoadTask());
    if (!isDisposed && outcome.data != null && !outcome.hasError) {
      final data = outcome.data!;
      if (!_initialized) {
        _original = data.expense;
        if (_original != null) {
          _isIncome = _original!.isIncome;
          _selectedDate = _original!.date;
          if (isIncome) {
            _incomeCategoryId = _original!.category.id;
          } else {
            _expenseCategoryId = _original!.category.id;
          }
        }
        _initialized = true;
      }
      _expenseCategoryId ??= _initialCategoryId(data.categories, false);
      _incomeCategoryId ??= _initialCategoryId(data.categories, true);
      notifyListeners();
    }
  }

  String? _initialCategoryId(
    List<TransactionCategory> categories,
    bool income,
  ) {
    final active = categories
        .where(
          (category) => !category.isArchived && category.isIncome == income,
        )
        .toList();
    if (active.isEmpty) return null;
    final defaultId = income ? 'default-income' : 'default-food';
    return active
            .where((category) => category.id == defaultId)
            .firstOrNull
            ?.id ??
        active.first.id;
  }

  void selectIncome(bool value) {
    if (isDisposed || isLoading || isFetching) return;
    _isIncome = value;
    notifyListeners();
  }

  void selectCategory(TransactionCategory category) {
    if (isDisposed ||
        isLoading ||
        isFetching ||
        !availableCategories.any((saved) => saved.id == category.id)) {
      return;
    }
    if (isIncome) {
      _incomeCategoryId = category.id;
    } else {
      _expenseCategoryId = category.id;
    }
    notifyListeners();
  }

  void selectDate(DateTime date) {
    if (isDisposed || isLoading || isFetching) return;
    _selectedDate = date;
    notifyListeners();
  }

  Future<ActionState> save({
    required String title,
    required int amountMinor,
  }) async {
    if (!canSave) throw StateError('Transaction categories are not ready');
    final expense = Expense(
      id: _original?.id,
      syncId: _original?.syncId,
      title: title,
      currencyCode: currencyCode,
      amountMinor: amountMinor,
      date: selectedDate,
      category: selectedCategory!,
      isIncome: isIncome,
    );
    return isEditing
        ? execute(createUpdateAction(expense))
        : execute(createSaveAction(expense));
  }
}
