import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

// These fields match the existing SQLite columns.
@freezed
abstract class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    int? id,
    required String title,
    required double amount,
    required String date,
    required int category,
    required int isIncome,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
