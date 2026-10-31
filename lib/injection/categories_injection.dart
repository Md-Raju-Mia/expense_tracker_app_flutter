import 'package:get_it/get_it.dart';

import '../data/datasources/local/category_local_data_source.dart';
import '../data/datasources/local/expense_local_data_source.dart';
import '../data/repositories/category_repository_impl.dart';
import '../domain/actions/categories_archive_action.dart';
import '../domain/actions/categories_save_action.dart';
import '../domain/entities/category_draft.dart';
import '../domain/repositories/category_repository.dart';
import '../domain/tasks/categories/archive_category_task.dart';
import '../domain/tasks/categories/load_categories_task.dart';
import '../domain/tasks/categories/save_category_task.dart';

void configureCategoriesDependencies(GetIt container) {
  container.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSource(container<ExpenseLocalDataSource>()),
  );
  container.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(container<CategoryLocalDataSource>()),
  );
  container.registerFactoryParam<LoadCategoriesTask, bool?, void>(
    (includeArchived, _) => LoadCategoriesTask(
      container<CategoryRepository>(),
      includeArchived: includeArchived ?? false,
    ),
  );
  container.registerFactoryParam<SaveCategoryTask, CategoryDraft, void>(
    (draft, _) => SaveCategoryTask(container<CategoryRepository>(), draft),
  );
  container.registerFactoryParam<ArchiveCategoryTask, String, bool>(
    (id, archived) => ArchiveCategoryTask(
      container<CategoryRepository>(),
      id,
      archived: archived,
    ),
  );
  container.registerFactoryParam<CategoriesSaveAction, CategoryDraft, void>(
    (draft, _) =>
        CategoriesSaveAction(container<SaveCategoryTask>(param1: draft)),
  );
  container.registerFactoryParam<CategoriesArchiveAction, String, bool>(
    (id, archived) => CategoriesArchiveAction(
      container<ArchiveCategoryTask>(param1: id, param2: archived),
    ),
  );
}
