import 'package:flutter/services.dart';

import '../../domain/entities/expense_history_report.dart';
import '../../domain/repositories/expense_history_pdf_repository.dart';

class ExpenseHistoryPdfRepositoryImpl implements ExpenseHistoryPdfRepository {
  const ExpenseHistoryPdfRepositoryImpl();

  static const _channel = MethodChannel('expense_tracker/history_pdf');

  @override
  Future<bool> export(
    ExpenseHistoryReport report, {
    required bool share,
  }) async => (await _channel.invokeMethod<bool>(share ? 'share' : 'export', {
    'title': report.title,
    'period': report.period,
    'count': report.count,
    'rows': [
      for (final row in report.rows)
        {'title': row.title, 'details': row.details, 'amount': row.amount},
    ],
  }))!;
}
