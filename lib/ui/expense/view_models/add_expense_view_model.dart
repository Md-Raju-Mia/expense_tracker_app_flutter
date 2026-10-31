import '../../../core/base/base_view_model.dart';
import '../../../core/state/action_state.dart';
import '../../../domain/actions/expense_save_action.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/expense_category.dart';

class AddExpenseViewModel extends BaseViewModel {
  AddExpenseViewModel({
    required this.createSaveAction,
    DateTime? initialDate,
    this.currencyCode = 'USD',
  }) : _selectedDate = initialDate ?? DateTime.now();

  final ExpenseSaveAction Function(Expense expense) createSaveAction;
  final String currencyCode;
  DateTime _selectedDate;
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  bool _isIncome = false;

  DateTime get selectedDate => _selectedDate;
  ExpenseCategory get selectedCategory => _selectedCategory;
  bool get isIncome => _isIncome;

  void selectIncome(bool value) {
    if (isDisposed) return;
    _isIncome = value;
    notifyListeners();
  }

  void selectCategory(ExpenseCategory category) {
    if (isDisposed) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    if (isDisposed) return;
    _selectedDate = date;
    notifyListeners();
  }

  Future<ActionState> save({required String title, required int amountMinor}) {
    final expense = Expense(
      title: title,
      currencyCode: currencyCode,
      amountMinor: amountMinor,
      date: selectedDate,
      category: isIncome ? ExpenseCategory.income : selectedCategory,
      isIncome: isIncome,
    );
    // The screen can pop immediately. Accepted work finishes after disposal.
    return execute(createSaveAction(expense));
  }
}
