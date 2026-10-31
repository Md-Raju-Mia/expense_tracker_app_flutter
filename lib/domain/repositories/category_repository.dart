import '../entities/category_draft.dart';
import '../entities/transaction_category.dart';

abstract class CategoryRepository {
  Future<List<TransactionCategory>> getCategories({
    bool includeArchived = false,
  });
  Future<String> saveCategory(CategoryDraft draft);
  // Archive instead of delete so old transaction references remain valid.
  Future<void> setArchived(String id, bool archived);
}
