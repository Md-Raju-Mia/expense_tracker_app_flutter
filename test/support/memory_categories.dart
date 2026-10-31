import 'dart:async';

import 'package:fleet_wise_user_app/domain/actions/categories_archive_action.dart';
import 'package:fleet_wise_user_app/domain/actions/categories_save_action.dart';
import 'package:fleet_wise_user_app/domain/entities/category_draft.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/repositories/category_repository.dart';
import 'package:fleet_wise_user_app/domain/tasks/categories/archive_category_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/categories/load_categories_task.dart';
import 'package:fleet_wise_user_app/domain/tasks/categories/save_category_task.dart';
import 'package:fleet_wise_user_app/ui/categories/view_models/categories_view_model.dart';

class MemoryCategories implements CategoryRepository {
  final rows = <TransactionCategory>[
    const TransactionCategory(
      id: 'default-food',
      name: 'Food',
      icon: CategoryIcon.food,
      color: CategoryColor.orange,
      isIncome: false,
      builtInKey: 'food',
    ),
    const TransactionCategory(
      id: 'default-income',
      name: 'Income',
      icon: CategoryIcon.income,
      color: CategoryColor.green,
      isIncome: true,
      builtInKey: 'income',
    ),
  ];
  Object? readError;
  Object? writeError;
  Completer<void>? pendingSave;
  int writes = 0;
  CategoryDraft? lastDraft;

  @override
  Future<List<TransactionCategory>> getCategories({
    bool includeArchived = false,
  }) async {
    if (readError != null) throw readError!;
    return rows.where((row) => includeArchived || !row.isArchived).toList();
  }

  @override
  Future<String> saveCategory(CategoryDraft draft) async {
    writes++;
    lastDraft = draft;
    if (pendingSave != null) await pendingSave!.future;
    if (writeError != null) throw writeError!;
    final id = draft.id ?? 'created-$writes';
    final previous = rows.where((row) => row.id == id).firstOrNull;
    rows.removeWhere((row) => row.id == id);
    rows.add(
      TransactionCategory(
        id: id,
        name: draft.name.trim(),
        icon: draft.icon,
        color: draft.color,
        isIncome: draft.isIncome,
        builtInKey: previous?.name == draft.name ? previous?.builtInKey : null,
      ),
    );
    return id;
  }

  @override
  Future<void> setArchived(String id, bool archived) async {
    if (writeError != null) throw writeError!;
    final index = rows.indexWhere((row) => row.id == id);
    final row = rows[index];
    rows[index] = TransactionCategory(
      id: row.id,
      name: row.name,
      icon: row.icon,
      color: row.color,
      isIncome: row.isIncome,
      builtInKey: row.builtInKey,
      isArchived: archived,
    );
  }
}

CategoriesViewModel categoriesModel(MemoryCategories repository) =>
    CategoriesViewModel(
      createLoadTask: () =>
          LoadCategoriesTask(repository, includeArchived: true),
      createSaveAction: (draft) =>
          CategoriesSaveAction(SaveCategoryTask(repository, draft)),
      createArchiveAction: (id, archived) => CategoriesArchiveAction(
        ArchiveCategoryTask(repository, id, archived: archived),
      ),
    );
