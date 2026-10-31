import 'package:flutter/material.dart';

import '../../../core/base/base_view.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_page_content.dart';
import '../../../domain/entities/category_exception.dart';
import '../../../domain/entities/transaction_category.dart';
import '../../../l10n/l10n.dart';
import '../view_models/categories_view_model.dart';
import '../widgets/category_card.dart';
import '../widgets/category_editor.dart';
import '../widgets/category_style.dart';

class CategoriesScreen extends BaseView<CategoriesViewModel> {
  const CategoriesScreen({super.key});

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    CategoriesViewModel viewModel,
  ) => AppBar(
    toolbarHeight: MediaQuery.textScalerOf(context).scale(24) + 32,
    title: Text(
      context.l10n.categoriesTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    actions: [
      if (!viewModel.editing)
        IconButton(
          tooltip: context.l10n.categoriesRefresh,
          onPressed: viewModel.canInteract ? viewModel.load : null,
          icon: const Icon(Icons.refresh),
        ),
    ],
  );

  @override
  String? errorMessage(BuildContext context, CategoriesViewModel viewModel) {
    final text = context.l10n;
    final failure = viewModel.state.error;
    if (failure is CategoryException) {
      return switch (failure.problem) {
        CategoryProblem.invalidName => text.categoriesNameInvalid,
        CategoryProblem.duplicateName => text.categoriesDuplicate,
        CategoryProblem.notFound => text.categoriesMissing,
        CategoryProblem.archived => text.categoriesAlreadyArchived,
        CategoryProblem.typeChange => text.categoriesTypeFixed,
      };
    }
    if (failure != null) return text.categoriesWriteError;
    if (viewModel.contentState.hasError) return text.categoriesLoadError;
    return null;
  }

  @override
  Widget? bottomNavigationBar(
    BuildContext context,
    CategoriesViewModel viewModel,
  ) {
    if (viewModel.editing || !viewModel.contentState.hasData) return null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: FilledButton.icon(
          key: const ValueKey('category-add'),
          onPressed: viewModel.canInteract ? viewModel.startNew : null,
          icon: const Icon(Icons.add),
          label: Text(context.l10n.categoriesAdd),
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context, CategoriesViewModel viewModel) {
    final text = context.l10n;
    if (!viewModel.contentState.hasData) {
      return Center(
        child: viewModel.contentState.hasError
            ? FilledButton.icon(
                onPressed: viewModel.load,
                icon: const Icon(Icons.refresh),
                label: Text(text.retry),
              )
            : CircularProgressIndicator(semanticsLabel: text.loading),
      );
    }
    if (viewModel.editing) {
      return AppPageContent(
        child: CategoryEditor(
          key: ValueKey(viewModel.editorVersion),
          model: viewModel,
        ),
      );
    }
    return AppPageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.categoriesDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: Text(text.expenseTypeExpense),
                selected: !viewModel.filterIncome,
                onSelected: viewModel.canInteract
                    ? (_) => viewModel.filter(isIncome: false)
                    : null,
              ),
              ChoiceChip(
                label: Text(text.expenseIncome),
                selected: viewModel.filterIncome,
                onSelected: viewModel.canInteract
                    ? (_) => viewModel.filter(isIncome: true)
                    : null,
              ),
            ],
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: Text(text.categoriesActive),
                selected: !viewModel.showArchived,
                onSelected: viewModel.canInteract
                    ? (_) => viewModel.filter(archived: false)
                    : null,
              ),
              ChoiceChip(
                label: Text(text.categoriesArchived),
                selected: viewModel.showArchived,
                onSelected: viewModel.canInteract
                    ? (_) => viewModel.filter(archived: true)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (viewModel.isFetching) const LinearProgressIndicator(),
          if (viewModel.contentState.hasError)
            TextButton.icon(
              onPressed: viewModel.isFetching ? null : viewModel.load,
              icon: const Icon(Icons.refresh),
              label: Text(text.retry),
            ),
          if (viewModel.visibleCategories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Text(text.categoriesEmpty),
            ),
          for (final category in viewModel.visibleCategories)
            CategoryCard(
              key: ValueKey(category.id),
              category: category,
              enabled: viewModel.canInteract,
              onEdit: () => viewModel.startEdit(
                category,
                displayName: category.label(context),
              ),
              onArchive: () => _archive(context, viewModel, category),
            ),
        ],
      ),
    );
  }

  Future<void> _archive(
    BuildContext context,
    CategoriesViewModel viewModel,
    TransactionCategory category,
  ) async {
    if (!viewModel.canInteract) return;
    if (category.isArchived) {
      await viewModel.setArchived(category, false);
      return;
    }
    final text = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(text.categoriesArchive),
        content: Text(text.categoriesArchivePrompt(category.label(context))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(text.expenseCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(text.categoriesArchive),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted && viewModel.canInteract) {
      await viewModel.setArchived(category, true);
    }
  }
}
