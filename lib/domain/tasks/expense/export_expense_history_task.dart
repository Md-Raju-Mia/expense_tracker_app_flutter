import '../../../core/base/base_task.dart';
import '../../entities/expense_history_report.dart';
import '../../repositories/expense_history_pdf_repository.dart';

class ExportExpenseHistoryTask extends BaseTask<bool> {
  const ExportExpenseHistoryTask(
    this.repository,
    this.report, {
    required this.share,
  });

  final ExpenseHistoryPdfRepository repository;
  final ExpenseHistoryReport report;
  final bool share;

  @override
  String get name => 'Export expense history';

  @override
  Future<bool> run() => repository.export(report, share: share);
}
