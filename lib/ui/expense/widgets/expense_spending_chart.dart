import 'package:flutter/material.dart';

import '../../../domain/entities/expense_summary.dart';
import '../../../l10n/l10n.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'expense_amount.dart';

import '../../categories/widgets/category_style.dart';

class ExpenseSpendingChart extends StatelessWidget {
  const ExpenseSpendingChart({super.key, required this.summary});
  final ExpenseSummary summary;
  @override
  Widget build(BuildContext context) {
    final totals = summary.categoryTotalsMinor;
    final labels = categoryLabels(context, totals.keys);
    final amountText = expenseAmount(
      summary.totalExpenseMinor,
      summary.currencyCode,
      context.l10n.localeName,
    );
    final showAmountBelowChart =
        MediaQuery.textScalerOf(context).scale(16) > 24 ||
        amountText.length > 8;
    if (totals.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 55,
                    sections: totals.entries.map((entry) {
                      return PieChartSectionData(
                        // The chart needs doubles only for drawing proportions.
                        value: entry.value.toDouble(),
                        showTitle: false,
                        radius: 40,
                        color: entry.key.color.palette,
                        badgeWidget: _Badge(
                          entry.key.icon.materialIcon,
                          size: 35,
                          borderColor: entry.key.color.palette,
                        ),
                        badgePositionPercentageOffset: 1.15,
                      );
                    }).toList(),
                  ),
                ),
                if (!showAmountBelowChart)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.expenseSpent,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        expenseAmount(
                          summary.totalExpenseMinor,
                          summary.currencyCode,
                          context.l10n.localeName,
                        ),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (showAmountBelowChart) ...[
            const SizedBox(height: 16),
            Text(
              context.l10n.expenseSpent,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              expenseAmount(
                summary.totalExpenseMinor,
                summary.currencyCode,
                context.l10n.localeName,
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: totals.entries.map((entry) {
              final percent = NumberFormat('0.0', context.l10n.localeName)
                  .format(
                    summary.totalExpenseMinor > BigInt.zero
                        ? entry.value.toDouble() /
                              summary.totalExpenseMinor.toDouble() *
                              100
                        : 0,
                  );
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: entry.key.color.palette,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      context.l10n.expenseCategoryPercent(
                        labels[entry.key.id]!,
                        percent,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.icon, {required this.size, required this.borderColor});
  final IconData icon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon, color: borderColor, size: size * .6),
      ),
    );
  }
}
