import '../../../core/base/base_task.dart';
import '../../repositories/category_repository.dart';

class ArchiveCategoryTask extends BaseTask<void> {
  const ArchiveCategoryTask(this.repository, this.id, {required this.archived});
  final CategoryRepository repository;
  final String id;
  final bool archived;

  @override
  String get name => archived ? 'Archive category' : 'Restore category';

  @override
  Future<void> run() => repository.setArchived(id, archived);
}
