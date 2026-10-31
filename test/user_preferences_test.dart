import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:fleet_wise_user_app/core/storage/app_preferences.dart';
import 'package:fleet_wise_user_app/core/state/action_state.dart';
import 'package:fleet_wise_user_app/data/datasources/local/user_preferences_local_data_source.dart';
import 'package:fleet_wise_user_app/data/repositories/user_preferences_repository_impl.dart';
import 'package:fleet_wise_user_app/domain/entities/user_country.dart';
import 'package:fleet_wise_user_app/domain/entities/user_currency.dart';
import 'package:fleet_wise_user_app/domain/entities/user_language.dart';
import 'package:fleet_wise_user_app/domain/entities/user_preferences.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:fleet_wise_user_app/ui/preferences/view_models/user_preferences_view_model.dart';

import 'support/memory_user_preferences.dart';

void main() {
  setUp(
    () => SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty(),
  );
  tearDown(() => SharedPreferencesAsyncPlatform.instance = null);

  test('fresh storage defaults to Bangladesh, BDT and Bengali', () async {
    final repository = UserPreferencesRepositoryImpl(
      UserPreferencesLocalDataSource(SharedPreferencesAppPreferences()),
    );
    final saved = await repository.load();
    expect(saved.country, UserCountry.bangladesh);
    expect(saved.currency, UserCurrency.bdt);
    expect(saved.language, UserLanguage.bengali);
  });

  test('recreated repository retains independent country currency and language choices', () async {
    final repository = UserPreferencesRepositoryImpl(
      UserPreferencesLocalDataSource(SharedPreferencesAppPreferences()),
    );
    await repository.save(
      const UserPreferences(
        country: UserCountry.bangladesh,
        currency: UserCurrency.usd,
        language: UserLanguage.english,
      ),
    );
    final reopened = UserPreferencesRepositoryImpl(
      UserPreferencesLocalDataSource(SharedPreferencesAppPreferences()),
    );
    final saved = await reopened.load();
    expect(saved.country, UserCountry.bangladesh);
    expect(saved.currency, UserCurrency.usd);
    expect(saved.language, UserLanguage.english);
  });

  test(
    'unreadable preferences are reported without deleting the saved record',
    () async {
      final storage = SharedPreferencesAppPreferences();
      await storage.setString(
        UserPreferencesLocalDataSource.storageKey,
        'broken-json',
      );
      final repository = UserPreferencesRepositoryImpl(
        UserPreferencesLocalDataSource(storage),
      );
      await expectLater(repository.load(), throwsFormatException);
      expect(
        await storage.getString(UserPreferencesLocalDataSource.storageKey),
        'broken-json',
      );
    },
  );

  test('country suggests defaults and individual overrides are saved independently', () async {
    final repository = MemoryUserPreferences();
    final model = preferencesModel(repository);
    addTearDown(model.dispose);
    await model.load();
    model.selectCountry(UserCountry.india);
    expect(model.draft.currency, UserCurrency.inr);
    expect(model.draft.language, UserLanguage.english);
    model.selectCurrency(UserCurrency.usd);
    model.selectLanguage(UserLanguage.bengali);
    final result = await model.save();
    expect(result.status, ActionStatus.succeeded);
    expect(repository.saved.country, UserCountry.india);
    expect(repository.saved.currency, UserCurrency.usd);
    expect(repository.saved.language, UserLanguage.bengali);
  });

  test('reselecting the same country retains manual overrides', () async {
    final model = preferencesModel(MemoryUserPreferences());
    addTearDown(model.dispose);
    await model.load();
    model.selectCurrency(UserCurrency.usd);
    model.selectLanguage(UserLanguage.english);
    model.selectCountry(UserCountry.bangladesh);
    expect(model.draft.currency, UserCurrency.usd);
    expect(model.draft.language, UserLanguage.english);
  });

  test('load error is retryable and saving before load is rejected', () async {
    final repository = MemoryUserPreferences()
      ..loadError = StateError('read failed');
    final model = preferencesModel(repository);
    addTearDown(model.dispose);
    expect(() => model.save(), throwsStateError);
    await model.load();
    expect(model.contentState.hasError, isTrue);
    repository.loadError = null;
    await model.load();
    expect(model.contentState.hasData, isTrue);
  });

  test('failed save keeps choices and supports an explicit retry', () async {
    final failure = StateError('write failed');
    final repository = MemoryUserPreferences()..saveError = failure;
    final model = preferencesModel(repository);
    addTearDown(model.dispose);
    await model.load();
    model.selectCurrency(UserCurrency.usd);
    final result = await model.save();
    expect(result.error, same(failure));
    expect(result.failedTask, 'Save preferences');
    expect(model.draft.currency, UserCurrency.usd);
    expect(repository.saved.currency, UserCurrency.bdt);
    repository.saveError = null;
    await model.save();
    expect(repository.saved.currency, UserCurrency.usd);
  });

  test('busy save rejects duplicates and completes after disposal without notification', () async {
    final repository = MemoryUserPreferences()..pendingSave = Completer<void>();
    final model = preferencesModel(repository);
    await model.load();
    model.selectCurrency(UserCurrency.usd);
    final pending = model.save();
    model.selectCountry(UserCountry.india);
    expect(model.draft.country, UserCountry.bangladesh);
    await expectLater(model.save(), throwsStateError);
    model.dispose();
    repository.pendingSave!.complete();
    expect((await pending).status, ActionStatus.succeeded);
    expect(repository.saved.currency, UserCurrency.usd);
  });

  test('dependency factories keep screen models independent', () async {
    final container = GetIt.asNewInstance();
    configureDependencies(container);
    addTearDown(container.reset);
    final first = container<UserPreferencesViewModel>();
    final second = container<UserPreferencesViewModel>();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    expect(first, isNot(same(second)));
    await first.load();
    first.selectCountry(UserCountry.india);
    await first.save();
    await second.load();
    expect(second.draft.country, UserCountry.india);
  });
}
