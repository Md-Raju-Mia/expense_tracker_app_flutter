import 'package:flutter/material.dart';

import '../../../core/base/base_view.dart';
import '../../../l10n/l10n.dart';
import '../view_models/post_detail_view_model.dart';
import '../widgets/post_detail_content.dart';

class PostDetailScreen extends BaseView<PostDetailViewModel> {
  const PostDetailScreen({super.key});

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    PostDetailViewModel viewModel,
  ) => AppBar(title: Text(context.l10n.postTitle));

  @override
  Widget body(BuildContext context, PostDetailViewModel model) =>
      PostDetailContent(model: model);
}
