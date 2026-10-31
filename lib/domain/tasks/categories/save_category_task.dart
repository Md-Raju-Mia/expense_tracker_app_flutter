import '../../../core/base/base_task.dart';
import '../../entities/category_draft.dart';
import '../../repositories/category_repository.dart';

class SaveCategoryTask extends BaseTask<String> {
  const SaveCategoryTask(this.repository, this.draft);
  final CategoryRepository repository;
  final CategoryDraft draft;

  @override
  String get name => 'Save category';

  @override
  Future<String> run() async {
    draft.validate();
    return repository.saveCategory(draft);
  }
}
