import 'package:fleet_wise_user_app/data/datasources/local/category_local_data_source.dart';
import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/domain/actions/categories_archive_action.dart';
import 'package:fleet_wise_user_app/domain/actions/categories_save_action.dart';
import 'package:fleet_wise_user_app/domain/entities/category_draft.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/tasks/categories/load_categories_task.dart';
import 'package:fleet_wise_user_app/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('category actions are fresh, share the owned database and record failed task names', () async {
    sqfliteFfiInit();
    final container = GetIt.asNewInstance();
    configureDependencies(container);
    addTearDown(container.reset);
    await container.unregister<ExpenseLocalDataSource>();
    container.registerLazySingleton<ExpenseLocalDataSource>(
      () => ExpenseLocalDataSource(
        factory: databaseFactoryFfi,
        databasePath: inMemoryDatabasePath,
      ),
      dispose: (source) => source.close(),
    );
    expect(
      container<CategoryLocalDataSource>().databaseSource,
      same(container<ExpenseLocalDataSource>()),
    );
    const draft = CategoryDraft(
      name: 'Rent',
      icon: CategoryIcon.home,
      color: CategoryColor.teal,
      isIncome: false,
    );
    final action = container<CategoriesSaveAction>(param1: draft);
    expect(action, isNot(same(container<CategoriesSaveAction>(param1: draft))));
    await action.run();
    final categories = await container<LoadCategoriesTask>().run();
    final saved = categories.singleWhere((row) => row.name == 'Rent');
    await container<CategoriesArchiveAction>(
      param1: saved.id,
      param2: true,
    ).run();
    expect(await container<LoadCategoriesTask>().run(), hasLength(7));
    expect(
      await container<LoadCategoriesTask>(param1: true).run(),
      hasLength(8),
    );
    await container<CategoriesArchiveAction>(
      param1: saved.id,
      param2: false,
    ).run();
    final duplicate = container<CategoriesSaveAction>(param1: draft);
    await expectLater(duplicate.run(), throwsA(isA<CategoryException>()));
    expect(duplicate.failedTask, 'Save category');
    final db = await container<ExpenseLocalDataSource>().database;
    await container.reset();
    expect(db.isOpen, isFalse);
  });
}
