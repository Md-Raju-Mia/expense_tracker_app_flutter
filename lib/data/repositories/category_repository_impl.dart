import 'package:uuid/uuid.dart';

import '../../domain/entities/category_draft.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local/category_local_data_source.dart';
import '../mappers/category_mapper.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this.source);
  final CategoryLocalDataSource source;

  @override
  Future<List<TransactionCategory>> getCategories({
    bool includeArchived = false,
  }) async {
    final models = await source.getCategories(includeArchived: includeArchived);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<String> saveCategory(CategoryDraft draft) async {
    draft.validate();
    final name = draft.name.trim();
    return source.saveCategory(
      CategoryModel(
        id: draft.id ?? const Uuid().v4(),
        name: name,
        normalizedName: name.replaceAll(RegExp(r'\s+'), ' ').toLowerCase(),
        iconKey: draft.icon.name,
        colorKey: draft.color.name,
        isIncome: draft.isIncome ? 1 : 0,
      ),
      isNew: draft.id == null,
    );
  }

  @override
  Future<void> setArchived(String id, bool archived) =>
      source.setArchived(id, archived);
}
