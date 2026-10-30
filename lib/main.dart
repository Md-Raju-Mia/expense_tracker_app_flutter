import 'l10n/l10n.dart';
import 'core/theme/app_theme.dart';
import 'injection/injection.dart';

import 'package:fleet_wise_user_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  configureDependencies(getIt);
  runApp(const PostsApp());
}

class PostsApp extends StatefulWidget {
  const PostsApp({super.key});

  @override
  State<PostsApp> createState() => _PostsAppState();
}

class _PostsAppState extends State<PostsApp> {
  late final GoRouter _router = AppPages.createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (context) => context.l10n.appTitle,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    routerConfig: _router,
  );
}
