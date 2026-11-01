import 'package:fleet_wise_user_app/domain/entities/transaction_category.dart';

// Fixtures only: the application always loads categories from its repository.
abstract final class TestCategories {
  static const food = TransactionCategory(
    id: 'default-food',
    name: 'Food',
    icon: CategoryIcon.food,
    color: CategoryColor.orange,
    isIncome: false,
    builtInKey: 'food',
  );
  static const transport = TransactionCategory(
    id: 'default-transport',
    name: 'Transport',
    icon: CategoryIcon.transport,
    color: CategoryColor.blue,
    isIncome: false,
    builtInKey: 'transport',
  );
  static const entertainment = TransactionCategory(
    id: 'default-entertainment',
    name: 'Entertainment',
    icon: CategoryIcon.entertainment,
    color: CategoryColor.purple,
    isIncome: false,
    builtInKey: 'entertainment',
  );
  static const shopping = TransactionCategory(
    id: 'default-shopping',
    name: 'Shopping',
    icon: CategoryIcon.shopping,
    color: CategoryColor.pink,
    isIncome: false,
    builtInKey: 'shopping',
  );
  static const health = TransactionCategory(
    id: 'default-health',
    name: 'Health',
    icon: CategoryIcon.health,
    color: CategoryColor.red,
    isIncome: false,
    builtInKey: 'health',
  );
  static const others = TransactionCategory(
    id: 'default-others',
    name: 'Others',
    icon: CategoryIcon.others,
    color: CategoryColor.grey,
    isIncome: false,
    builtInKey: 'others',
  );
  static const income = TransactionCategory(
    id: 'default-income',
    name: 'Income',
    icon: CategoryIcon.income,
    color: CategoryColor.green,
    isIncome: true,
    builtInKey: 'income',
  );
  static const values = [
    food,
    transport,
    entertainment,
    shopping,
    health,
    others,
    income,
  ];
}
