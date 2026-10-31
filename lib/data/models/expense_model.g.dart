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
        currencyCode: $checkedConvert(
          'currencyCode',
          (v) => v as String? ?? 'USD',
        ),
        title: $checkedConvert('title', (v) => v as String),
        amountMinor: $checkedConvert('amountMinor', (v) => (v as num).toInt()),
        legacyAmount: $checkedConvert('amount', (v) => (v as num?)?.toDouble()),
        date: $checkedConvert('date', (v) => v as String),
        category: $checkedConvert('category', (v) => (v as num).toInt()),
        isIncome: $checkedConvert('isIncome', (v) => (v as num).toInt()),
      );
      return val;
    }, fieldKeyMap: const {'legacyAmount': 'amount'});

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'syncId': instance.syncId,
      'currencyCode': instance.currencyCode,
      'title': instance.title,
      'amountMinor': instance.amountMinor,
      'amount': instance.legacyAmount,
      'date': instance.date,
      'category': instance.category,
      'isIncome': instance.isIncome,
    };
