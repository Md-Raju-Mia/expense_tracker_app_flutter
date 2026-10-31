// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ExpenseModel', json, ($checkedConvert) {
      final val = _ExpenseModel(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        syncId: $checkedConvert('syncId', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as String),
        amount: $checkedConvert('amount', (v) => (v as num).toDouble()),
        date: $checkedConvert('date', (v) => v as String),
        category: $checkedConvert('category', (v) => (v as num).toInt()),
        isIncome: $checkedConvert('isIncome', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'syncId': instance.syncId,
      'title': instance.title,
      'amount': instance.amount,
      'date': instance.date,
      'category': instance.category,
      'isIncome': instance.isIncome,
    };
