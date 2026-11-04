import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../core/ads/ads_session.dart';
import '../../../core/theme/app_dimensions.dart';

class ExpenseHistoryBanner extends StatelessWidget {
  const ExpenseHistoryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final unitId = context.select<AdsSession?, String?>(
      (session) => session?.visibleBannerId,
    );
    if (unitId == null || ModalRoute.isCurrentOf(context) == false) {
      return const SizedBox.shrink();
    }

    final screenPadding = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            (constraints.maxWidth -
                    screenPadding.horizontal -
                    2 * AppSpacing.lg)
                .clamp(0, AppLayout.contentMaxWidth)
                .floor();
        if (width < 150) return const SizedBox.shrink();
        final orientation = MediaQuery.orientationOf(context);
        return _SizedBanner(
          key: ValueKey((unitId, width, orientation)),
          unitId: unitId,
          width: width,
          orientation: orientation,
        );
      },
    );
  }
}

class _SizedBanner extends StatefulWidget {
  const _SizedBanner({
    super.key,
    required this.unitId,
    required this.width,
    required this.orientation,
  });

  final String unitId;
  final int width;
  final Orientation orientation;

  @override
  State<_SizedBanner> createState() => _SizedBannerState();
}

class _SizedBannerState extends State<_SizedBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final size =
          await AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(
            widget.orientation,
            widget.width,
          );
      if (!mounted || size == null) return;
      final ad = BannerAd(
        adUnitId: widget.unitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            if (mounted && _ad != null) setState(() => _loaded = true);
          },
          onAdFailedToLoad: (_, _) => _failed(),
        ),
      );
      _ad = ad;
      await ad.load();
    } catch (_) {
      _failed();
    }
  }

  void _failed() {
    _discardAd();
    if (mounted && _loaded) setState(() => _loaded = false);
  }

  void _discardAd() {
    final ad = _ad;
    _ad = null;
    if (ad != null) unawaited(ad.dispose());
  }

  @override
  void dispose() {
    _discardAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Center(
            heightFactor: 1,
            child: SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
      ),
    );
  }
}
