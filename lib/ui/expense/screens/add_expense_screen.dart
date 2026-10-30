import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view.dart';
import '../../../core/state/action_state.dart';
import '../../../core/theme/expense_theme.dart';
import '../../../l10n/l10n.dart';
import '../view_models/add_expense_view_model.dart';
import '../widgets/expense_transaction_form.dart';

class AddExpenseScreen extends BaseView<AddExpenseViewModel> {
  const AddExpenseScreen({super.key, required this.onSaved});
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: Theme(
        data: ExpenseTheme.light,
        child: Builder(
          builder: (context) =>
              pageScaffold(context, context.watch<AddExpenseViewModel>()),
        ),
      ),
    );
  }

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    AddExpenseViewModel viewModel,
  ) {
    return AppBar(
      title: Text(
        context.l10n.expenseAddTransaction,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
    );
  }

  @override
  Widget pageContent(BuildContext context, AddExpenseViewModel viewModel) =>
      body(context, viewModel);

  @override
  Widget body(BuildContext context, AddExpenseViewModel viewModel) {
    return ExpenseTransactionForm(
      viewModel: viewModel,
      onSubmit: (title, amount) {
        // Capture the callback before popping. No BuildContext is used later.
        final refreshHome = onSaved;
        final pending = viewModel.save(title: title, amount: amount);
        pending.then((outcome) {
          if (outcome.status == ActionStatus.succeeded) refreshHome();
        });
        context.pop();
      },
    );
  }
}
