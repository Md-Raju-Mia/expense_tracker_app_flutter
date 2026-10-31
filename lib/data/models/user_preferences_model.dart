import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences_model.freezed.dart';
part 'user_preferences_model.g.dart';

@freezed
abstract class UserPreferencesModel with _$UserPreferencesModel {
  const factory UserPreferencesModel({
    required String countryCode,
    required String currencyCode,
    required String languageCode,
  }) = _UserPreferencesModel;

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);
}
