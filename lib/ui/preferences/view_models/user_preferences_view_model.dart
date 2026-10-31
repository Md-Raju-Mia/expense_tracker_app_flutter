import '../../../core/base/content_view_model.dart';
import '../../../core/state/action_state.dart';
import '../../../domain/actions/preferences_save_action.dart';
import '../../../domain/entities/user_country.dart';
import '../../../domain/entities/user_currency.dart';
import '../../../domain/entities/user_language.dart';
import '../../../domain/entities/user_preferences.dart';
import '../../../domain/tasks/preferences/load_user_preferences_task.dart';

class UserPreferencesViewModel extends ContentViewModel<UserPreferences> {
  UserPreferencesViewModel({
    required this.createLoadTask,
    required this.createSaveAction,
  });

  final LoadUserPreferencesTask Function() createLoadTask;
  final PreferencesSaveAction Function(UserPreferences preferences)
  createSaveAction;
  UserPreferences _draft = const UserPreferences();
  UserPreferences get draft => _draft;
  UserPreferences? _savedPreferences;
  UserPreferences? get savedPreferences => _savedPreferences;

  @override
  bool isEmptyResult(UserPreferences data) => false;

  Future<void> load() async {
    if (isDisposed || isFetching || isLoading) return;
    final outcome = await loadContent(createLoadTask());
    if (!isDisposed && outcome.data != null && !outcome.hasError) {
      _draft = outcome.data!;
      _savedPreferences = outcome.data!;
      notifyListeners();
    }
  }

  void selectCountry(UserCountry country) {
    if (isDisposed || isLoading || isFetching) return;
    if (_draft.country == country) return;
    _draft = UserPreferences.forCountry(country);
    notifyListeners();
  }

  void selectCurrency(UserCurrency currency) {
    if (isDisposed || isLoading || isFetching) return;
    _draft = UserPreferences(
      country: _draft.country,
      currency: currency,
      language: _draft.language,
    );
    notifyListeners();
  }

  void selectLanguage(UserLanguage language) {
    if (isDisposed || isLoading || isFetching) return;
    _draft = UserPreferences(
      country: _draft.country,
      currency: _draft.currency,
      language: language,
    );
    notifyListeners();
  }

  Future<ActionState> save() {
    if (isFetching || !contentState.hasData) {
      throw StateError('Preferences have not loaded');
    }
    final selected = _draft;
    return execute(createSaveAction(selected)).then((outcome) {
      if (!isDisposed && outcome.status == ActionStatus.succeeded) {
        _savedPreferences = selected;
        notifyListeners();
      }
      return outcome;
    });
  }

  void discardChanges() {
    if (isDisposed || isLoading) return;
    _draft = _savedPreferences ?? const UserPreferences();
    resetState();
    notifyListeners();
  }
}
