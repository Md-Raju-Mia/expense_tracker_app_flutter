import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ads/ads_session.dart';
import '../../../l10n/l10n.dart';

class AdsPrivacyButton extends StatelessWidget {
  const AdsPrivacyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AdsSession?>();
    if (session == null || !session.privacyRequired) {
      return const SizedBox.shrink();
    }
    return OutlinedButton(
      onPressed: session.editingPrivacy
          ? null
          : () async {
              final shown = await session.showPrivacyOptions();
              if (!context.mounted || shown) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.adsPrivacyError)),
              );
            },
      child: Text(context.l10n.adsPrivacyOptions),
    );
  }
}
