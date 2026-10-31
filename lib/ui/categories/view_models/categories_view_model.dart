import '../../../core/base/content_view_model.dart';
import '../../../core/state/action_state.dart';
import '../../../domain/actions/categories_archive_action.dart';
import '../../../domain/actions/categories_save_action.dart';
import '../../../domain/entities/category_draft.dart';
import '../../../domain/entities/transaction_category.dart';
import '../../../domain/tasks/categories/load_categories_task.dart';

class CategoriesViewModel extends ContentViewModel<List<TransactionCategory>> {
  CategoriesViewModel({
    required this.createLoadTask,
    required this.createSaveAction,
    required this.createArchiveAction,
  });
  final LoadCategoriesTask Function() createLoadTask;
  final CategoriesSaveAction Function(CategoryDraft) createSaveAction;
  final CategoriesArchiveAction Function(String id, bool archived)
  createArchiveAction;

  bool showArchived = false;
  bool filterIncome = false;
  bool editing = false;
  int editorVersion = 0;
  String? _editingId;
  String? get editingId => _editingId;
  String _initialDisplayName = '';
  String _originalName = '';
  String get name => _name;
  String _name = '';
  CategoryIcon icon = CategoryIcon.others;
  CategoryColor color = CategoryColor.teal;
  bool income = false;
  bool get isExisting => _editingId != null;
  bool get canInteract =>
      !isDisposed && !isLoading && !isFetching && contentState.hasData;
  List<TransactionCategory> get visibleCategories => (contentState.data ?? [])
      .where(
        (row) => row.isArchived == showArchived && row.isIncome == filterIncome,
      )
      .toList();

  @override
  bool isEmptyResult(List<TransactionCategory> data) => data.isEmpty;

  Future<void> load() async {
    if (isDisposed || isLoading || isFetching) return;
    await loadContent(createLoadTask());
  }

  void filter({bool? archived, bool? isIncome}) {
    if (!canInteract) return;
    showArchived = archived ?? showArchived;
    filterIncome = isIncome ?? filterIncome;
    resetState();
    notifyListeners();
  }

  void startNew() {
    if (!canInteract) return;
    _editingId = null;
    _name = '';
    icon = filterIncome ? CategoryIcon.income : CategoryIcon.others;
    color = CategoryColor.teal;
    income = filterIncome;
    _openEditor();
  }

  void startEdit(TransactionCategory category, {required String displayName}) {
    if (!canInteract || category.isArchived) return;
    _editingId = category.id;
    _initialDisplayName = displayName;
    _originalName = category.name;
    _name = displayName;
    icon = category.icon;
    color = category.color;
    income = category.isIncome;
    _openEditor();
  }

  void _openEditor() {
    editing = true;
    editorVersion++;
    resetState();
    notifyListeners();
  }

  void changeName(String value) {
    if (canInteract) _name = value;
  }

  void selectIcon(CategoryIcon value) {
    if (!canInteract) return;
    icon = value;
    notifyListeners();
  }

  void selectColor(CategoryColor value) {
    if (!canInteract) return;
    color = value;
    notifyListeners();
  }

  void selectIncome(bool value) {
    if (!canInteract || isExisting) return;
    income = value;
    notifyListeners();
  }

  void cancelEdit() {
    if (!canInteract) return;
    editing = false;
    resetState();
    notifyListeners();
  }

  Future<ActionState> save() async {
    if (!canInteract || !editing) {
      throw StateError('Category editor is not ready');
    }
    // An unchanged translated label is not a user rename of the stored name.
    final savedName = isExisting && _name.trim() == _initialDisplayName
        ? _originalName
        : _name;
    final draft = CategoryDraft(
      id: _editingId,
      name: savedName,
      icon: icon,
      color: color,
      isIncome: income,
    );
    final outcome = await execute(createSaveAction(draft));
    if (!isDisposed && outcome.status == ActionStatus.succeeded) {
      editing = false;
      showArchived = false;
      filterIncome = income;
      await load();
    }
    return outcome;
  }

  Future<ActionState> setArchived(
    TransactionCategory category,
    bool archived,
  ) async {
    if (!canInteract || editing) throw StateError('Categories are busy');
    final outcome = await execute(createArchiveAction(category.id, archived));
    if (!isDisposed && outcome.status == ActionStatus.succeeded) await load();
    return outcome;
  }
}
