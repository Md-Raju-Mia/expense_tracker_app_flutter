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

// Distinct IDs may have the same translated name, or reuse an archived name.
// Keep those categories separate and give the user a readable distinction.
Map<String, String> categoryLabels(
  BuildContext context,
  Iterable<TransactionCategory> categories,
) {
  final unique = {for (final category in categories) category.id: category};
  final groups = <String, List<TransactionCategory>>{};
  String normalized(String name) =>
      name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  for (final category in unique.values) {
    final key = normalized(category.label(context));
    groups.putIfAbsent(key, () => []).add(category);
  }
  final labels = <String, String>{};
  for (final category in unique.values) {
    var label = category.label(context);
    final sameName = groups[normalized(label)]!;
    final matching = sameName.where(
      (other) => other.isArchived == category.isArchived,
    );
    if (matching.length > 1) {
      label = category.id.startsWith('default-')
          ? context.l10n.expenseDefaultCategory(label)
          : context.l10n.expenseCustomCategory(label);
    }
    if (category.isArchived) {
      label = context.l10n.expenseArchivedCategory(label);
    }
    labels[category.id] = label;
  }
  return labels;
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
