import 'dart:async';

import 'core/ads/ads_config.dart';
import 'core/ads/ads_session.dart';
import 'l10n/l10n.dart';
import 'core/theme/app_theme.dart';
import 'injection/injection.dart';

import 'package:fleet_wise_user_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  configureDependencies(getIt);
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key, this.initialLocation});

  final String? initialLocation;

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late final AdsSession _ads;
  late final GoRouter _router = AppPages.createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void initState() {
    super.initState();
    _ads = AdsSession(bannerId: AdsConfig.current().historyBannerId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_ads.start());
    });
  }

  @override
  void dispose() {
    _ads.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: _ads,
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (_) =>
          lookupAppLocalizations(const Locale('en')).expenseTrackerTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    ),
  );
}
