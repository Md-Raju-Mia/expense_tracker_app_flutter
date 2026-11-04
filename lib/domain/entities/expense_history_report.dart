typedef ExpenseHistoryReportRow = ({
  String title,
  String details,
  String amount,
});

class ExpenseHistoryReport {
  const ExpenseHistoryReport({
    required this.title,
    required this.period,
    required this.count,
    required this.rows,
  });

  final String title;
  final String period;
  final String count;
  final List<ExpenseHistoryReportRow> rows;
}
