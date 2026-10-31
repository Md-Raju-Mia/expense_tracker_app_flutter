// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferencesModel _$UserPreferencesModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_UserPreferencesModel', json, ($checkedConvert) {
  final val = _UserPreferencesModel(
    countryCode: $checkedConvert('countryCode', (v) => v as String),
    currencyCode: $checkedConvert('currencyCode', (v) => v as String),
    languageCode: $checkedConvert('languageCode', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$UserPreferencesModelToJson(
  _UserPreferencesModel instance,
) => <String, dynamic>{
  'countryCode': instance.countryCode,
  'currencyCode': instance.currencyCode,
  'languageCode': instance.languageCode,
};
