import '../entities/expense_history_report.dart';

abstract interface class ExpenseHistoryPdfRepository {
  Future<bool> export(ExpenseHistoryReport report, {required bool share});
}
