import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view.dart';
import '../../../core/theme/expense_theme.dart';
import '../../../l10n/l10n.dart';
import '../view_models/expense_home_view_model.dart';
import '../widgets/expense_empty_state.dart';
import '../widgets/expense_home_content.dart';

class ExpenseHomeScreen extends BaseView<ExpenseHomeViewModel> {
  const ExpenseHomeScreen({super.key, required this.onAddTransaction});

  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context) {
    // Keep the old app's English/light appearance and nonblocking writes.
    // The route still owns the model; this view only observes it.
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: Theme(
        data: ExpenseTheme.light,
        child: Builder(
          builder: (context) =>
              pageScaffold(context, context.watch<ExpenseHomeViewModel>()),
        ),
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
      title: Text(
        context.l10n.expenseTrackerTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
    );
  }

  @override
  Widget pageContent(BuildContext context, ExpenseHomeViewModel viewModel) =>
      body(context, viewModel);

  @override
  Widget body(BuildContext context, ExpenseHomeViewModel viewModel) {
    final summary = viewModel.contentState.data;
    if (summary == null || summary.expenses.isEmpty) {
      return const ExpenseEmptyState();
    }
    return ExpenseHomeContent(
      summary: summary,
      onDelete: (id) => _showDeleteDialog(context, viewModel, id),
    );
  }

  @override
  Widget floatingActionButton(
    BuildContext context,
    ExpenseHomeViewModel viewModel,
  ) {
    return FloatingActionButton.extended(
      onPressed: onAddTransaction,
      label: Text(context.l10n.expenseAddTask),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.teal,
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
