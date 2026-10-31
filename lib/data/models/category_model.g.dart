// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CategoryModel', json, ($checkedConvert) {
      final val = _CategoryModel(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        normalizedName: $checkedConvert('normalizedName', (v) => v as String),
        iconKey: $checkedConvert('iconKey', (v) => v as String),
        colorKey: $checkedConvert('colorKey', (v) => v as String),
        isIncome: $checkedConvert('isIncome', (v) => (v as num).toInt()),
        builtInKey: $checkedConvert('builtInKey', (v) => v as String?),
        isArchived: $checkedConvert(
          'isArchived',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'normalizedName': instance.normalizedName,
      'iconKey': instance.iconKey,
      'colorKey': instance.colorKey,
      'isIncome': instance.isIncome,
      'builtInKey': instance.builtInKey,
      'isArchived': instance.isArchived,
    };
