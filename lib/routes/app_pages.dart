import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../injection/injection.dart';
import '../l10n/l10n.dart';
import '../ui/posts/view_models/post_detail_view_model.dart';
import '../ui/posts/view_models/posts_view_model.dart';
import '../ui/posts/screens/post_detail_screen.dart';
import '../ui/posts/screens/posts_screen.dart';

part 'app_routes.dart';

/// Page registration and Provider composition stay outside the MVVM core.
class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.MAIN;

  static final routes = <RouteBase>[
    GoRoute(path: _Paths.MAIN, redirect: (_, _) => Routes.POSTS),
    GoRoute(
      name: Routes.POSTS,
      path: _Paths.POSTS,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => getIt<PostsViewModel>()..initialize(),
          child: const PostsScreen(),
        );
      },
      routes: [
        GoRoute(
          name: Routes.POST_DETAIL,
          path: ':postId',
          redirect: (_, state) {
            final id = int.tryParse(state.pathParameters['postId'] ?? '');
            return id == null || id <= 0 ? Routes.POSTS : null;
          },
          builder: (_, state) {
            final id = int.parse(state.pathParameters['postId']!);
            return ChangeNotifierProvider(
              key: ValueKey(id),
              create: (_) => getIt<PostDetailViewModel>(param1: id)..load(),
              child: const PostDetailScreen(),
            );
          },
        ),
      ],
    ),
  ];

  /// The app owns this router; no global router or view model is retained here.
  static GoRouter createRouter({String? initialLocation}) => GoRouter(
    // Preserve platform deep links while using the template's default page.
    initialLocation: initialLocation ?? INITIAL,
    routes: routes,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.pageNotFound)),
      body: Center(
        child: FilledButton(
          onPressed: () => context.go(Routes.POSTS),
          child: Text(context.l10n.goToPosts),
        ),
      ),
    ),
  );
}
