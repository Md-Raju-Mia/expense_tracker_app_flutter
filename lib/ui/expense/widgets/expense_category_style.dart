import 'package:flutter/material.dart';

import '../../../domain/entities/expense_category.dart';

extension ExpenseCategoryStyle on ExpenseCategory {
  IconData get icon => switch (this) {
    ExpenseCategory.food => Icons.restaurant,
    ExpenseCategory.transport => Icons.directions_car,
    ExpenseCategory.entertainment => Icons.movie,
    ExpenseCategory.shopping => Icons.shopping_cart,
    ExpenseCategory.health => Icons.medical_services,
    ExpenseCategory.others => Icons.more_horiz,
    ExpenseCategory.income => Icons.attach_money,
  };

  Color get color => switch (this) {
    ExpenseCategory.food => Colors.orange,
    ExpenseCategory.transport => Colors.blue,
    ExpenseCategory.entertainment => Colors.purple,
    ExpenseCategory.shopping => Colors.pink,
    ExpenseCategory.health => Colors.red,
    ExpenseCategory.others => Colors.grey,
    ExpenseCategory.income => Colors.green,
  };
}
