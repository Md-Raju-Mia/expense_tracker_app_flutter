import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsConsent {
  const AdsConsent();

  Future<void> update() async {
    final completion = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => completion.complete(),
      (error) => completion.completeError(error),
    );
    await completion.future;

    final form = Completer<FormError?>();
    await ConsentForm.loadAndShowConsentFormIfRequired(form.complete);
    final error = await form.future;
    if (error != null) throw error;
  }

  Future<bool> canRequestAds() => ConsentInformation.instance.canRequestAds();

  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  Future<bool> showPrivacyOptions() async {
    final form = Completer<bool>();
    await ConsentForm.showPrivacyOptionsForm(
      (error) => form.complete(error == null),
    );
    return form.future;
  }

  Future<void> initializeAds() async {
    await MobileAds.instance.initialize();
  }
}
