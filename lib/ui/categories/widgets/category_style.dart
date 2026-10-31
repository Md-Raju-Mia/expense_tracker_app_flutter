import 'package:flutter/material.dart';

import '../../../domain/entities/transaction_category.dart';
import '../../../l10n/l10n.dart';

extension CategoryPresentation on TransactionCategory {
  String label(BuildContext context) => switch (builtInKey) {
    'food' => context.l10n.expenseCategoryFood,
    'transport' => context.l10n.expenseCategoryTransport,
    'entertainment' => context.l10n.expenseCategoryEntertainment,
    'shopping' => context.l10n.expenseCategoryShopping,
    'health' => context.l10n.expenseCategoryHealth,
    'others' => context.l10n.expenseCategoryOthers,
    'income' => context.l10n.expenseCategoryIncome,
    _ => name,
  };
}

extension CategoryIconStyle on CategoryIcon {
  IconData get materialIcon => switch (this) {
    CategoryIcon.food => Icons.restaurant_outlined,
    CategoryIcon.transport => Icons.directions_car_outlined,
    CategoryIcon.entertainment => Icons.movie_outlined,
    CategoryIcon.shopping => Icons.shopping_bag_outlined,
    CategoryIcon.health => Icons.medical_services_outlined,
    CategoryIcon.others => Icons.category_outlined,
    CategoryIcon.income => Icons.payments_outlined,
    CategoryIcon.home => Icons.home_outlined,
    CategoryIcon.education => Icons.school_outlined,
    CategoryIcon.bills => Icons.receipt_long_outlined,
    CategoryIcon.gift => Icons.card_giftcard_outlined,
    CategoryIcon.work => Icons.work_outline,
  };
}

extension CategoryColorStyle on CategoryColor {
  MaterialColor get palette => switch (this) {
    CategoryColor.orange => Colors.orange,
    CategoryColor.blue => Colors.blue,
    CategoryColor.purple => Colors.purple,
    CategoryColor.pink => Colors.pink,
    CategoryColor.red => Colors.red,
    CategoryColor.grey => Colors.grey,
    CategoryColor.green => Colors.green,
    CategoryColor.teal => Colors.teal,
    CategoryColor.indigo => Colors.indigo,
    CategoryColor.brown => Colors.brown,
  };
  Color foreground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? palette.shade200
      : palette.shade800;
}
