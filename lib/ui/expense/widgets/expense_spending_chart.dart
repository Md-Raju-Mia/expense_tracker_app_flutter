import 'package:flutter/material.dart';

import '../../../domain/entities/expense_summary.dart';
import '../../../l10n/l10n.dart';

import 'package:fl_chart/fl_chart.dart';

import 'expense_category_style.dart';

class ExpenseSpendingChart extends StatelessWidget {
  const ExpenseSpendingChart({super.key, required this.summary});
  final ExpenseSummary summary;
  @override
  Widget build(BuildContext context) {
    final totals = summary.categoryTotals;
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
                        value: entry.value,
                        showTitle: false,
                        radius: 40,
                        color: entry.key.color,
                        badgeWidget: _Badge(
                          entry.key.icon,
                          size: 35,
                          borderColor: entry.key.color,
                        ),
                        badgePositionPercentageOffset: 1.15,
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.expenseSpent,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '\$${summary.totalExpense.toStringAsFixed(0)}',
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
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: totals.entries.map((entry) {
              final percent = summary.totalExpense > 0
                  ? (entry.value / summary.totalExpense * 100).toStringAsFixed(
                      1,
                    )
                  : '0.0';
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: entry.key.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.key.name}: $percent%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
