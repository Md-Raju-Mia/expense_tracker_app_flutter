import 'package:flutter/material.dart';

import '../../../domain/entities/expense_category.dart';
import '../../../l10n/l10n.dart';

extension ExpenseCategoryStyle on ExpenseCategory {
  String label(BuildContext context) => switch (this) {
    ExpenseCategory.food => context.l10n.expenseCategoryFood,
    ExpenseCategory.transport => context.l10n.expenseCategoryTransport,
    ExpenseCategory.entertainment => context.l10n.expenseCategoryEntertainment,
    ExpenseCategory.shopping => context.l10n.expenseCategoryShopping,
    ExpenseCategory.health => context.l10n.expenseCategoryHealth,
    ExpenseCategory.others => context.l10n.expenseCategoryOthers,
    ExpenseCategory.income => context.l10n.expenseCategoryIncome,
  };
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
