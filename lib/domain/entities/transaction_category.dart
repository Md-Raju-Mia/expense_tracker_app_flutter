enum CategoryIcon {
  food,
  transport,
  entertainment,
  shopping,
  health,
  others,
  income,
  home,
  education,
  bills,
  gift,
  work,
}

enum CategoryColor {
  orange,
  blue,
  purple,
  pink,
  red,
  grey,
  green,
  teal,
  indigo,
  brown,
}

class TransactionCategory {
  const TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isIncome,
    this.builtInKey,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final CategoryIcon icon;
  final CategoryColor color;
  final bool isIncome;
  // Used to translate unchanged built-in names. Custom names stay as entered.
  final String? builtInKey;
  final bool isArchived;
}
