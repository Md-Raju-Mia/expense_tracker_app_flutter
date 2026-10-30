import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local/expense_local_data_source.dart';
import '../mappers/expense_mapper.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._source);

  final ExpenseLocalDataSource _source;

  @override
  Future<List<Expense>> getExpenses() async {
    final models = await _source.getExpenses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<int> insertExpense(Expense expense) {
    return _source.insertExpense(expense.toModel());
  }

  @override
  Future<int> deleteExpense(int id) {
    return _source.deleteExpense(id);
  }
}
