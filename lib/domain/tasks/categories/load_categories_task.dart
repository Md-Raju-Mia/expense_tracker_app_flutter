import '../../../core/base/base_task.dart';
import '../../entities/transaction_category.dart';
import '../../repositories/category_repository.dart';

class LoadCategoriesTask extends BaseTask<List<TransactionCategory>> {
  const LoadCategoriesTask(this.repository, {this.includeArchived = false});
  final CategoryRepository repository;
  final bool includeArchived;

  @override
  String get name => 'Load categories';

  @override
  Future<List<TransactionCategory>> run() =>
      repository.getCategories(includeArchived: includeArchived);
}
