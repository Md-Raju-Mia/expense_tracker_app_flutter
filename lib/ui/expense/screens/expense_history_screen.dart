import 'package:flutter/material.dart';

import '../../../core/base/base_view.dart';
import '../../../core/theme/expense_theme.dart';
import '../../../l10n/l10n.dart';
import '../view_models/expense_history_view_model.dart';
import '../widgets/expense_history_banner.dart';
import '../widgets/expense_history_pdf_buttons.dart';
import '../widgets/expense_history_filters.dart';
import '../widgets/expense_transaction_list.dart';

class ExpenseHistoryScreen extends BaseView<ExpenseHistoryViewModel> {
  const ExpenseHistoryScreen({super.key, this.onEdit});
  final ValueChanged<int>? onEdit;

  @override
  Widget build(BuildContext context) => Theme(
    data: ExpenseTheme.light,
    child: Builder(builder: (context) => super.build(context)),
  );

  @override
  PreferredSizeWidget appBar(
    BuildContext context,
    ExpenseHistoryViewModel viewModel,
  ) => AppBar(
    toolbarHeight: MediaQuery.textScalerOf(context).scale(24) + 32,
    title: Text(
      context.l10n.expenseHistory,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    actions: [
      IconButton(
        onPressed: viewModel.isFetching ? null : viewModel.load,
        tooltip: context.l10n.retry,
        icon: const Icon(Icons.refresh),
      ),
    ],
  );

  @override
  String? errorMessage(
    BuildContext context,
    ExpenseHistoryViewModel viewModel,
  ) {
    if (viewModel.contentState.hasError) return context.l10n.expenseLoadError;
    if (viewModel.state.error != null) {
      return context.l10n.expenseHistoryPdfError;
    }
    return null;
  }

  @override
  Widget? bottomNavigationBar(
    BuildContext context,
    ExpenseHistoryViewModel viewModel,
  ) => viewModel.isLoading || viewModel.visibleExpenses.isEmpty
      ? null
      : const ExpenseHistoryBanner();

  @override
  Widget body(BuildContext context, ExpenseHistoryViewModel viewModel) {
    if (!viewModel.contentState.hasData) {
      return Center(
        child: viewModel.isFetching
            ? CircularProgressIndicator(semanticsLabel: context.l10n.loading)
            : FilledButton(
                onPressed: viewModel.load,
                child: Text(context.l10n.retry),
              ),
      );
    }
    final rows = viewModel.visibleExpenses;
    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExpenseHistoryFilters(model: viewModel),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.expenseHistoryCount(rows.length),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.expenseHistoryCurrencies),
                  ExpenseHistoryPdfButtons(model: viewModel),
                  if (viewModel.isFetching) const LinearProgressIndicator(),
                ],
              ),
            ),
          ),
          if (rows.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.expenseHistoryEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ExpenseTransactionList(expenses: rows, onEdit: onEdit),
        ],
      ),
    );
  }
}
