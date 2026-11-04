import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AndroidDailyReminder {
  const AndroidDailyReminder();

  static const _channel = MethodChannel('expense_tracker/daily_reminder');

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<Map<String, Object?>> load() async =>
      (await _channel.invokeMapMethod<String, Object?>('load'))!;

  Future<Map<String, Object?>> save(bool enabled, int minutes) async =>
      (await _channel.invokeMapMethod<String, Object?>('save', {
        'enabled': enabled,
        'minutes': minutes,
      }))!;
}
