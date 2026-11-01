import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/base/base_view.dart';
import '../../../core/state/action_state.dart';
import '../../../core/theme/expense_theme.dart';
import '../../../l10n/l10n.dart';
import '../../../domain/entities/category_exception.dart';
import '../view_models/add_expense_view_model.dart';
import '../widgets/expense_transaction_form.dart';

class AddExpenseScreen extends BaseView<AddExpenseViewModel> {
  const AddExpenseScreen({
    super.key,
    required this.onSaved,
    this.onManageCategories,
  });
  final VoidCallback onSaved;
  final Future<void> Function()? onManageCategories;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ExpenseTheme.light,
      child: Builder(builder: (context) => super.build(context)),
    );
  }

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    AddExpenseViewModel viewModel,
  ) {
    return AppBar(
      toolbarHeight: MediaQuery.textScalerOf(context).scale(24) + 32,
      title: Text(
        context.l10n.expenseAddTransaction,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
    );
  }

  @override
  String? errorMessage(BuildContext context, AddExpenseViewModel viewModel) {
    if (viewModel.state.error is CategoryException) {
      return context.l10n.expenseCategoryUnavailable;
    }
    if (viewModel.state.error != null) return context.l10n.expenseSaveError;
    if (viewModel.contentState.hasError) {
      return context.l10n.categoriesLoadError;
    }
    return null;
  }

  @override
  Widget body(BuildContext context, AddExpenseViewModel viewModel) {
    if (!viewModel.contentState.hasData) {
      return Center(
        child: viewModel.contentState.hasError
            ? FilledButton.icon(
                onPressed: viewModel.loadCategories,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.retry),
              )
            : CircularProgressIndicator(semanticsLabel: context.l10n.loading),
      );
    }
    return ExpenseTransactionForm(
      viewModel: viewModel,
      onManageCategories: onManageCategories == null
          ? null
          : () async {
              await onManageCategories!();
              if (context.mounted) await viewModel.loadCategories();
            },
      onSubmit: (title, amount) async {
        if (!viewModel.canSave) return;
        final refreshHome = onSaved;
        final outcome = await viewModel.save(title: title, amountMinor: amount);
        if (outcome.status == ActionStatus.succeeded) {
          refreshHome();
          if (context.mounted) context.pop();
        }
      },
    );
  }
}
