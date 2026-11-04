import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../domain/entities/expense_history_filter.dart';
import '../../../domain/entities/expense_history_report.dart';
import '../../../l10n/l10n.dart';
import '../../categories/widgets/category_style.dart';
import '../view_models/expense_history_view_model.dart';
import 'expense_amount.dart';

class ExpenseHistoryPdfButtons extends StatelessWidget {
  const ExpenseHistoryPdfButtons({super.key, required this.model});

  final ExpenseHistoryViewModel model;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb ||
        defaultTargetPlatform != TargetPlatform.android ||
        !model.supportsExport) {
      return const SizedBox.shrink();
    }
    final enabled = model.canExport;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        OutlinedButton.icon(
          onPressed: enabled ? () => _export(context, share: false) : null,
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: Text(context.l10n.expenseHistoryExportPdf),
        ),
        OutlinedButton.icon(
          onPressed: enabled ? () => _export(context, share: true) : null,
          icon: const Icon(Icons.share_outlined),
          label: Text(context.l10n.expenseHistorySharePdf),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, {required bool share}) async {
    final text = context.l10n;
    final locale = text.localeName;
    final dateFormat = DateFormat.yMMMd(locale);
    final expenses = model.visibleExpenses;
    final categories = categoryLabels(
      context,
      expenses.map((expense) => expense.category),
    );
    final period = switch (model.period) {
      ExpenseHistoryPeriod.all => text.expenseHistoryAll,
      ExpenseHistoryPeriod.day => dateFormat.format(model.date),
      ExpenseHistoryPeriod.month => DateFormat.yMMMM(locale).format(model.date),
      ExpenseHistoryPeriod.year => DateFormat.y(locale).format(model.date),
    };
    final saved = await model.export(
      ExpenseHistoryReport(
        title: text.expenseHistory,
        period: period,
        count: text.expenseHistoryCount(expenses.length),
        rows: [
          for (final expense in expenses)
            (
              title: expense.title,
              details: [
                dateFormat.format(expense.date),
                categories[expense.category.id]!,
                expense.isIncome ? text.expenseIncome : text.expenseTypeExpense,
              ].join('  •  '),
              amount:
                  '${expenseAmount(BigInt.from(expense.amountMinor), expense.currencyCode, locale)} ${expense.currencyCode}',
            ),
        ],
      ),
      share: share,
    );
    if (!context.mounted || !saved || share) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.expenseHistoryPdfSaved)),
    );
  }
}
