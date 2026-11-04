import 'package:flutter/foundation.dart';

import 'ads_consent.dart';

class AdsSession extends ChangeNotifier {
  AdsSession({required this.bannerId, this._consent = const AdsConsent()});

  final String? bannerId;
  final AdsConsent _consent;
  bool _started = false;
  bool _disposed = false;
  bool _initialized = false;
  bool _allowed = false;
  bool _privacyRequired = false;
  bool _editingPrivacy = false;

  String? get visibleBannerId => _allowed && !_editingPrivacy ? bannerId : null;
  bool get privacyRequired => _privacyRequired;
  bool get editingPrivacy => _editingPrivacy;

  Future<void> start() async {
    if (_started || _disposed || bannerId == null) return;
    _started = true;
    try {
      await _consent.update();
    } catch (_) {
      // UMP may still permit requests based on consent from a prior launch.
    }
    await _refresh();
  }

  Future<bool> showPrivacyOptions() async {
    if (_disposed || !_privacyRequired || _editingPrivacy) return false;
    _editingPrivacy = true;
    notifyListeners();
    try {
      return await _consent.showPrivacyOptions();
    } catch (_) {
      return false;
    } finally {
      await _refresh();
      _editingPrivacy = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _refresh() async {
    if (_disposed) return;
    try {
      _privacyRequired = await _consent.privacyOptionsRequired();
    } catch (_) {
      // Keep the last known requirement so the privacy entry stays accessible.
    }
    try {
      _allowed = await _consent.canRequestAds();
      if (_allowed && !_initialized && !_disposed) {
        await _consent.initializeAds();
        _initialized = true;
      }
    } catch (_) {
      _allowed = false;
    }
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
