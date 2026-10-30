// The public constructor argument intentionally initializes a private factory.
// ignore_for_file: prefer_initializing_formals

import '../../../core/base/base_task.dart';
import '../../../core/base/content_view_model.dart';
import '../../../domain/entities/feed.dart';

class PostDetailViewModel extends ContentViewModel<PostDetail> {
  PostDetailViewModel({
    required this.postId,
    required BaseTask<PostDetail> Function(int) createTask,
  }) : _createTask = createTask;
  final int postId;
  final BaseTask<PostDetail> Function(int) _createTask;
  @override
  bool isEmptyResult(PostDetail data) => false;
  Future<void> load() async {
    if (isFetching || isDisposed) return;
    await loadContent(_createTask(postId));
  }
}
