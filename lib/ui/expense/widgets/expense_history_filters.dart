import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/expense_history_filter.dart';
import '../../../l10n/l10n.dart';
import '../view_models/expense_history_view_model.dart';

class ExpenseHistoryFilters extends StatelessWidget {
  const ExpenseHistoryFilters({super.key, required this.model});
  final ExpenseHistoryViewModel model;

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final labels = {
      ExpenseHistoryPeriod.all: text.expenseHistoryAll,
      ExpenseHistoryPeriod.day: text.expenseHistoryDay,
      ExpenseHistoryPeriod.month: text.expenseHistoryMonth,
      ExpenseHistoryPeriod.year: text.expenseHistoryYear,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final period in ExpenseHistoryPeriod.values)
              ChoiceChip(
                key: ValueKey('history-period-${period.name}'),
                label: Text(labels[period]!),
                selected: model.period == period,
                onSelected: (_) => model.selectPeriod(period),
              ),
          ],
        ),
        if (model.period == ExpenseHistoryPeriod.day) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _chooseDate(context),
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              DateFormat.yMMMd(text.localeName).format(model.date),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        if (model.period == ExpenseHistoryPeriod.month) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('history-month-${model.date.month}'),
            initialValue: model.date.month,
            isExpanded: true,
            itemHeight: null,
            decoration: InputDecoration(labelText: text.expenseHistoryMonth),
            items: [
              for (var month = 1; month <= 12; month++)
                DropdownMenuItem(
                  value: month,
                  child: Text(
                    DateFormat.MMMM(text.localeName)
                        .format(DateTime(2000, month)),
                  ),
                ),
            ],
            onChanged: (month) {
              if (month != null) {
                model.selectDate(DateTime(model.date.year, month));
              }
            },
          ),
        ],
        if (model.period == ExpenseHistoryPeriod.month ||
            model.period == ExpenseHistoryPeriod.year) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey('history-year-${model.date.year}'),
            initialValue: model.date.year,
            isExpanded: true,
            itemHeight: null,
            decoration: InputDecoration(labelText: text.expenseHistoryYear),
            items: [
              for (final year in model.years)
                DropdownMenuItem(
                  value: year,
                  child: Text(NumberFormat('0', text.localeName).format(year)),
                ),
            ],
            onChanged: (year) {
              if (year != null) {
                model.selectDate(DateTime(year, model.date.month));
              }
            },
          ),
        ],
      ],
    );
  }

  Future<void> _chooseDate(BuildContext context) async {
    final years = model.years;
    final picked = await showDatePicker(
      context: context,
      helpText: context.l10n.expenseHistoryChooseDate,
      initialDate: model.date,
      firstDate: DateTime(years.last, 1, 1),
      lastDate: DateTime(years.first, 12, 31),
    );
    if (picked != null) model.selectDate(picked);
  }
}
