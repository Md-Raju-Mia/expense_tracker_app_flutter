import '../../../core/base/content_view_model.dart';
import '../../../core/state/action_state.dart';
import '../../../domain/actions/expense_save_action.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/transaction_category.dart';
import '../../../domain/tasks/categories/load_categories_task.dart';

class AddExpenseViewModel extends ContentViewModel<List<TransactionCategory>> {
  AddExpenseViewModel({
    required this.createSaveAction,
    required this.createLoadCategoriesTask,
    DateTime? initialDate,
    this.currencyCode = 'USD',
  }) : _selectedDate = initialDate ?? DateTime.now();

  final ExpenseSaveAction Function(Expense expense) createSaveAction;
  final LoadCategoriesTask Function() createLoadCategoriesTask;
  final String currencyCode;
  DateTime _selectedDate;
  String? _expenseCategoryId;
  String? _incomeCategoryId;
  bool _isIncome = false;

  DateTime get selectedDate => _selectedDate;
  List<TransactionCategory> get availableCategories => (contentState.data ?? [])
      .where(
        (category) => !category.isArchived && category.isIncome == isIncome,
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
  bool isEmptyResult(List<TransactionCategory> data) => data.isEmpty;

  Future<void> loadCategories() async {
    if (isDisposed || isLoading || isFetching) return;
    resetState();
    final outcome = await loadContent(createLoadCategoriesTask());
    if (!isDisposed && outcome.data != null && !outcome.hasError) {
      _expenseCategoryId ??= _initialCategoryId(outcome.data!, false);
      _incomeCategoryId ??= _initialCategoryId(outcome.data!, true);
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
      title: title,
      currencyCode: currencyCode,
      amountMinor: amountMinor,
      date: selectedDate,
      category: selectedCategory!,
      isIncome: isIncome,
    );
    return execute(createSaveAction(expense));
  }
}
