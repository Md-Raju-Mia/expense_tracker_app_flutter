import 'package:json_annotation/json_annotation.dart';

T decodeJsonObject<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value is! Map<String, dynamic>) {
    throw const FormatException('Expected a JSON object');
  }
  try {
    return fromJson(value);
  } on CheckedFromJsonException catch (error) {
    throw FormatException(error.message ?? 'Invalid JSON data', error);
  } on TypeError catch (error) {
    throw FormatException('Invalid JSON value type', error);
  }
}
