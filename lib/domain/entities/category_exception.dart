enum CategoryProblem {
  invalidName,
  duplicateName,
  notFound,
  archived,
  typeChange,
}

class CategoryException implements Exception {
  const CategoryException(this.problem);

  final CategoryProblem problem;

  @override
  String toString() => 'CategoryException: ${problem.name}';
}
