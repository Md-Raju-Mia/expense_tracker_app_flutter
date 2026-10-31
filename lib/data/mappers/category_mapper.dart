import '../../domain/entities/transaction_category.dart';
import '../models/category_model.dart';

extension CategoryModelMapper on CategoryModel {
  TransactionCategory toEntity() => TransactionCategory(
    id: id,
    name: name,
    icon: CategoryIcon.values.byName(iconKey),
    color: CategoryColor.values.byName(colorKey),
    isIncome: isIncome == 1,
    builtInKey: builtInKey,
    isArchived: isArchived == 1,
  );
}
