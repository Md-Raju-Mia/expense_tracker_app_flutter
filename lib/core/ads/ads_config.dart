import 'package:flutter/foundation.dart';

class AdsConfig {
  const AdsConfig({
    required this.android,
    required this.release,
    required this.testAds,
    required this.appId,
    required this.bannerId,
  });

  factory AdsConfig.current() => AdsConfig(
    android: !kIsWeb && defaultTargetPlatform == TargetPlatform.android,
    release: kReleaseMode,
    testAds: const bool.fromEnvironment('ADMOB_TEST_ADS'),
    appId: const String.fromEnvironment('ADMOB_ANDROID_APP_ID'),
    bannerId: const String.fromEnvironment('ADMOB_ANDROID_HISTORY_BANNER_ID'),
  );

  final bool android;
  final bool release;
  final bool testAds;
  final String appId;
  final String bannerId;

  static const _testPublisher = 'ca-app-pub-3940256099942544';
  static final _appFormat = RegExp(r'^ca-app-pub-[0-9]{16}~[0-9]{10}$');
  static final _bannerFormat = RegExp(r'^ca-app-pub-[0-9]{16}/[0-9]{10}$');

  String? get historyBannerId {
    if (!android) return null;
    if (!release) return testAds ? '$_testPublisher/9214589741' : null;
    if (testAds ||
        !_appFormat.hasMatch(appId) ||
        !_bannerFormat.hasMatch(bannerId)) {
      return null;
    }
    final publisher = appId.split('~').first;
    return publisher != _testPublisher && bannerId.startsWith('$publisher/')
        ? bannerId
        : null;
  }
}
