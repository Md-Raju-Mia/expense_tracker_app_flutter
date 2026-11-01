enum ExpenseProblem { notFound, identityChange, currencyChange }

class ExpenseException implements Exception {
  const ExpenseException(this.problem);
  final ExpenseProblem problem;

  @override
  String toString() => 'ExpenseException: ${problem.name}';
}
