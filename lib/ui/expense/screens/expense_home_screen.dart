import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view.dart';
import '../../../core/theme/expense_theme.dart';
import '../../../l10n/l10n.dart';
import '../view_models/expense_home_view_model.dart';
import '../widgets/expense_empty_state.dart';
import '../widgets/expense_home_content.dart';

class ExpenseHomeScreen extends BaseView<ExpenseHomeViewModel> {
  const ExpenseHomeScreen({
    super.key,
    required this.onAddTransaction,
    this.onOpenPreferences,
    this.onOpenCategories,
  });

  final VoidCallback onAddTransaction;
  final VoidCallback? onOpenPreferences;
  final VoidCallback? onOpenCategories;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ExpenseTheme.light,
      child: Builder(
        builder: (context) =>
            pageScaffold(context, context.watch<ExpenseHomeViewModel>()),
      ),
    );
  }

  @override
  Color? backgroundColor(BuildContext context) => Colors.grey[100];

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    ExpenseHomeViewModel viewModel,
  ) {
    return AppBar(
      toolbarHeight: MediaQuery.textScalerOf(context).scale(24) + 32,
      title: Text(
        context.l10n.expenseTrackerTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      actions: [
        if (onOpenCategories != null)
          IconButton(
            onPressed: onOpenCategories,
            tooltip: context.l10n.categoriesTitle,
            icon: const Icon(Icons.category_outlined),
          ),
        if (onOpenPreferences != null)
          IconButton(
            onPressed: onOpenPreferences,
            tooltip: context.l10n.preferencesAppBar,
            icon: const Icon(Icons.settings_outlined),
          ),
      ],
    );
  }

  @override
  Widget pageContent(BuildContext context, ExpenseHomeViewModel viewModel) =>
      body(context, viewModel);

  @override
  Widget body(BuildContext context, ExpenseHomeViewModel viewModel) {
    final summary = viewModel.contentState.data;
    if (summary == null) {
      if (viewModel.contentState.hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.expenseLoadError,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: viewModel.refresh,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.retry),
                ),
              ],
            ),
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(semanticsLabel: context.l10n.loading),
      );
    }
    if (summary.expenses.isEmpty) {
      return const ExpenseEmptyState();
    }
    return ExpenseHomeContent(
      summary: summary,
      onDelete: (id) => _showDeleteDialog(context, viewModel, id),
    );
  }

  @override
  Widget bottomNavigationBar(
    BuildContext context,
    ExpenseHomeViewModel viewModel,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: onAddTransaction,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            label: Text(
              context.l10n.expenseAddTransaction,
              textAlign: TextAlign.center,
            ),
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ExpenseHomeViewModel viewModel,
    int id,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.expenseDeleteTitle),
        content: Text(context.l10n.expenseDeletePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.expenseCancel),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteExpense(id);
              Navigator.pop(dialogContext);
            },
            child: Text(
              context.l10n.expenseDelete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
