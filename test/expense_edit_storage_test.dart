import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fleet_wise_user_app/data/datasources/local/expense_local_data_source.dart';
import 'package:fleet_wise_user_app/data/datasources/local/category_local_data_source.dart';
import 'package:fleet_wise_user_app/data/repositories/expense_repository_impl.dart';
import 'package:fleet_wise_user_app/data/repositories/category_repository_impl.dart';
import 'package:fleet_wise_user_app/domain/entities/expense.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/expense_summary.dart';
import 'package:fleet_wise_user_app/domain/entities/category_exception.dart';
import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';
import 'package:fleet_wise_user_app/domain/tasks/expense/update_expense_task.dart';

import 'support/test_categories.dart';

Expense change(
  Expense original, {
  String? title,
  int? amount,
  DateTime? date,
  TransactionCategory? category,
  bool? income,
  String? currency,
  String? syncId,
}) => Expense(
  id: original.id,
  syncId: syncId ?? original.syncId,
  currencyCode: currency ?? original.currencyCode,
  title: title ?? original.title,
  amountMinor: amount ?? original.amountMinor,
  date: date ?? original.date,
  category: category ?? original.category,
  isIncome: income ?? original.isIncome,
);

void main() {
  sqfliteFfiInit();
  late Directory folder;
  late ExpenseLocalDataSource source;
  late ExpenseRepositoryImpl expenses;
  late CategoryRepositoryImpl categories;
  setUp(() async {
    folder = await Directory.systemTemp.createTemp('expense_edit_');
    source = ExpenseLocalDataSource(
      factory: databaseFactoryFfi,
      databasePath: path.join(folder.path, 'expense.db'),
    );
    expenses = ExpenseRepositoryImpl(source);
    categories = CategoryRepositoryImpl(CategoryLocalDataSource(source));
  });
  tearDown(() async {
    await source.close();
    await folder.delete(recursive: true);
  });
  Future<Expense> create() async {
    final id = await expenses.insertExpense(
      Expense(
        title: 'Lunch',
        amountMinor: 1250,
        date: DateTime(2026, 4, 9, 12, 30),
        category: TestCategories.food,
      ),
    );
    return (await expenses.getExpense(id))!;
  }

  test('update persists editable fields without replacing identity, currency, audit data or other rows', () async {
    final original = await create();
    final neighbour = await create();
    final db = await source.database;
    await db.update(
      'expenses',
      {'amount': 12.345, 'category': 0},
      where: 'id = ?',
      whereArgs: [original.id],
    );
    final untouched = (await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [neighbour.id],
    )).single;
    final updated = change(
      original,
      title: 'Train',
      amount: 29,
      date: DateTime(2026, 3, 1),
      category: TestCategories.transport,
    );
    expect(await UpdateExpenseTask(expenses, updated).run(), 1);
    await source.close();
    final restored = (await expenses.getExpense(original.id!))!;
    expect(restored.id, original.id);
    expect(restored.syncId, original.syncId);
    expect(restored.currencyCode, 'USD');
    expect(restored.title, 'Train');
    expect(restored.amountMinor, 29);
    expect(restored.date, DateTime(2026, 3, 1));
    expect(restored.category.id, 'default-transport');
    final rows = await (await source.database).query('expenses', orderBy: 'id');
    expect(rows, hasLength(2));
    expect(rows.first['amount'], 12.345);
    expect(rows.first['category'], 0);
    expect(rows.last, untouched);
    expect(
      (await (await source.database).rawQuery('PRAGMA integrity_check'))
          .single
          .values
          .single,
      'ok',
    );
  });

  test('an archived original category may be retained but cannot receive another transaction', () async {
    final original = await create();
    await categories.setArchived(original.category.id, true);
    final archived = (await expenses.getExpense(original.id!))!;
    expect(archived.category.isArchived, isTrue);
    await UpdateExpenseTask(
      expenses,
      change(archived, title: 'Edited lunch', amount: 1),
    ).run();
    expect(
      (await expenses.getExpense(original.id!))!.category.id,
      original.category.id,
    );
    await expectLater(
      expenses.insertExpense(
        Expense(
          title: 'New',
          amountMinor: 1,
          date: DateTime(2026),
          category: archived.category,
        ),
      ),
      throwsA(isA<CategoryException>()),
    );
    expect(await expenses.getExpenses(), hasLength(1));
  });

  test(
    'moving to archived, wrong-type or missing categories fails atomically',
    () async {
      final original = await create();
      final db = await source.database;
      final before = await db.query('expenses');
      await categories.setArchived('default-transport', true);
      final missing = TransactionCategory(
        id: 'missing',
        name: 'Missing',
        icon: CategoryIcon.home,
        color: CategoryColor.teal,
        isIncome: false,
      );
      for (final proposed in [
        change(original, category: TestCategories.transport),
        change(original, income: true),
        change(original, category: missing),
      ]) {
        await expectLater(
          UpdateExpenseTask(expenses, proposed).run(),
          throwsA(isA<CategoryException>()),
        );
        expect(await db.query('expenses'), before);
      }
      await categories.setArchived('default-transport', false);
      await UpdateExpenseTask(
        expenses,
        change(original, category: TestCategories.transport),
      ).run();
      expect(
        (await expenses.getExpense(original.id!))!.category.id,
        'default-transport',
      );
    },
  );

  test('changing type uses a matching active category and recalculates totals once', () async {
    final original = await create();
    await UpdateExpenseTask(
      expenses,
      change(
        original,
        income: true,
        category: TestCategories.income,
        amount: 29,
      ),
    ).run();
    final rows = await expenses.getExpenses();
    final summary = ExpenseSummary(rows);
    expect(rows, hasLength(1));
    expect(rows.single.syncId, original.syncId);
    expect(summary.totalIncomeMinor, BigInt.from(29));
    expect(summary.totalExpenseMinor, BigInt.zero);
    expect(summary.balanceMinor, BigInt.from(29));
  });

  test('identity/currency changes fail and a deleted transaction is never recreated', () async {
    final original = await create();
    final db = await source.database;
    final before = await db.query('expenses');
    await expectLater(
      UpdateExpenseTask(expenses, change(original, currency: 'BDT')).run(),
      throwsA(
        isA<ExpenseException>().having(
          (e) => e.problem,
          'problem',
          ExpenseProblem.currencyChange,
        ),
      ),
    );
    await expectLater(
      UpdateExpenseTask(
        expenses,
        change(original, syncId: 'new-identity'),
      ).run(),
      throwsA(
        isA<ExpenseException>().having(
          (e) => e.problem,
          'problem',
          ExpenseProblem.identityChange,
        ),
      ),
    );
    expect(await db.query('expenses'), before);
    await expenses.deleteExpense(original.id!);
    await expectLater(
      UpdateExpenseTask(expenses, original).run(),
      throwsA(
        isA<ExpenseException>().having(
          (e) => e.problem,
          'problem',
          ExpenseProblem.notFound,
        ),
      ),
    );
    expect(await expenses.getExpense(original.id!), isNull);
    expect(await expenses.getExpenses(), isEmpty);
  });

  test('invalid title/amount edits cannot change a stored row', () async {
    final original = await create();
    final db = await source.database;
    final before = await db.query('expenses');
    for (final proposed in [
      change(original, title: '  '),
      change(original, amount: 0),
      change(original, amount: -1),
      change(original, amount: 1000000000000000),
    ]) {
      await expectLater(
        UpdateExpenseTask(expenses, proposed).run(),
        throwsA(anyOf(isA<FormatException>(), isA<RangeError>())),
      );
    }
    expect(await db.query('expenses'), before);
  });

  test('legacy type mismatch and archived reference are retained; unchanged raw date and audit amounts survive', () async {
    final db = await source.database;
    await db.insert('expenses', {
      'id': 42,
      'syncId': 'legacy-stable',
      'title': 'Legacy',
      'amount': -1.005,
      'amountMinor': -101,
      'currencyCode': 'USD',
      'date': '2019-01-01',
      'category': 0,
      'categoryId': 'default-food',
      'isIncome': 1,
    });
    await categories.setArchived('default-food', true);
    final original = (await expenses.getExpense(42))!;
    await UpdateExpenseTask(
      expenses,
      change(original, title: 'Corrected', amount: 101),
    ).run();
    final row = (await db.query('expenses', where: 'id = 42')).single;
    expect(row['id'], 42);
    expect(row['syncId'], 'legacy-stable');
    expect(row['currencyCode'], 'USD');
    expect(row['date'], '2019-01-01');
    expect(row['amount'], -1.005);
    expect(row['category'], 0);
    expect(row['amountMinor'], 101);
    expect(row['isIncome'], 1);
    expect(row['categoryId'], 'default-food');
  });
}
