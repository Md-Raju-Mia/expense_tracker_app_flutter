import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_model.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

// These fields match the existing SQLite columns.
@freezed
abstract class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    int? id,
    String? syncId,
    @Default('USD') String currencyCode,
    required String title,
    required int amountMinor,
    // Only old rows have this original REAL value. Never used in new totals.
    @JsonKey(name: 'amount') double? legacyAmount,
    required String date,
    required String categoryId,
    // Original enum index is retained on legacy rows only.
    int? category,
    // Loaded in the same SQLite read transaction; not a column in expenses.
    @JsonKey(includeFromJson: false, includeToJson: false)
    CategoryModel? categoryDetails,
    required int isIncome,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
