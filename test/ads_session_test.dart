import 'dart:async';

import 'package:fleet_wise_user_app/core/ads/ads_config.dart';
import 'package:fleet_wise_user_app/core/ads/ads_consent.dart';
import 'package:fleet_wise_user_app/core/ads/ads_session.dart';
import 'package:flutter_test/flutter_test.dart';

class _Consent extends AdsConsent {
  bool allowed = false;
  bool required = true;
  int updates = 0;
  int initializations = 0;
  final choice = Completer<bool>();

  @override
  Future<void> update() async => updates++;

  @override
  Future<bool> canRequestAds() async => allowed;

  @override
  Future<bool> privacyOptionsRequired() async => required;

  @override
  Future<bool> showPrivacyOptions() => choice.future;

  @override
  Future<void> initializeAds() async => initializations++;
}

void main() {
  test(
    'build modes separate test IDs, matching production IDs and disabled ads',
    () {
      String? id({
        bool android = true,
        bool release = false,
        bool test = false,
        String appId = '',
        String bannerId = '',
      }) => AdsConfig(
        android: android,
        release: release,
        testAds: test,
        appId: appId,
        bannerId: bannerId,
      ).historyBannerId;

      const app = 'ca-app-pub-1234567890123456~1234567890';
      const banner = 'ca-app-pub-1234567890123456/1234567890';
      expect(id(), isNull);
      expect(id(android: false, test: true), isNull);
      expect(id(test: true), 'ca-app-pub-3940256099942544/9214589741');
      expect(id(release: true, test: true), isNull);
      expect(id(appId: app, bannerId: banner), isNull);
      expect(id(release: true, bannerId: banner), isNull);
      expect(id(release: true, appId: app, bannerId: banner), banner);
      expect(
        id(
          release: true,
          appId: app,
          bannerId: 'ca-app-pub-9234567890123456/1234567890',
        ),
        isNull,
      );
    },
  );

  test('disabled ads never touch the consent SDK', () async {
    final consent = _Consent();
    final session = AdsSession(bannerId: null, consent: consent);
    addTearDown(session.dispose);
    await session.start();
    expect(consent.updates, 0);
    expect(session.visibleBannerId, isNull);
  });

  test(
    'consent gates initialization and privacy changes remove the banner',
    () async {
      final consent = _Consent()..allowed = true;
      final session = AdsSession(bannerId: 'banner', consent: consent);
      addTearDown(session.dispose);

      expect(session.visibleBannerId, isNull);
      await Future.wait([session.start(), session.start()]);
      expect(consent.updates, 1);
      expect(consent.initializations, 1);
      expect(session.privacyRequired, isTrue);
      expect(session.visibleBannerId, 'banner');

      final editing = session.showPrivacyOptions();
      expect(session.editingPrivacy, isTrue);
      expect(session.visibleBannerId, isNull);
      expect(await session.showPrivacyOptions(), isFalse);
      consent.allowed = false;
      consent.choice.complete(true);
      expect(await editing, isTrue);
      expect(session.visibleBannerId, isNull);
      expect(consent.initializations, 1);
    },
  );

  test('SDK initialization waits until consent permits ads', () async {
    final consent = _Consent();
    final session = AdsSession(bannerId: 'banner', consent: consent);
    addTearDown(session.dispose);
    await session.start();
    expect(consent.initializations, 0);
    expect(session.visibleBannerId, isNull);
    final editing = session.showPrivacyOptions();
    consent.allowed = true;
    consent.choice.complete(true);
    await editing;
    expect(consent.initializations, 1);
    expect(session.visibleBannerId, 'banner');
  });
}
