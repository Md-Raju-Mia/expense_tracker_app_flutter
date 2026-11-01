import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../injection/injection.dart';
import '../l10n/l10n.dart';
import '../ui/expense/screens/expense_form_screen.dart';
import '../ui/expense/screens/expense_home_screen.dart';
import '../ui/expense/view_models/expense_form_view_model.dart';
import '../ui/expense/view_models/expense_home_view_model.dart';
import '../ui/expense/widgets/expense_journey.dart';
import '../ui/categories/screens/categories_screen.dart';
import '../ui/categories/view_models/categories_view_model.dart';
import '../ui/preferences/screens/user_preferences_screen.dart';
import '../ui/preferences/view_models/user_preferences_view_model.dart';
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
    GoRoute(path: _Paths.MAIN, redirect: (_, _) => Routes.EXPENSES),
    ShellRoute(
      // The expense journey owns home state while the form is on top.
      builder: (_, state, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => getIt<UserPreferencesViewModel>()..load(),
          ),
          ChangeNotifierProvider(create: (_) => getIt<ExpenseHomeViewModel>()),
        ],
        child: ExpenseJourney(child: child),
      ),
      routes: [
        GoRoute(
          name: Routes.EXPENSES,
          path: _Paths.EXPENSES,
          builder: (context, state) => ExpenseHomeScreen(
            onAddTransaction: () => context.pushNamed(Routes.ADD_EXPENSE),
            onOpenPreferences: () => context.pushNamed(Routes.PREFERENCES),
            onOpenCategories: () => context.pushNamed(Routes.CATEGORIES),
            onEditTransaction: (id) => context.pushNamed(
              Routes.EDIT_EXPENSE,
              pathParameters: {'expenseId': '$id'},
            ),
          ),
          routes: [
            GoRoute(
              name: Routes.CATEGORIES,
              path: 'categories',
              builder: (context, state) {
                final home = context.read<ExpenseHomeViewModel>();
                return ChangeNotifierProvider(
                  create: (_) => getIt<CategoriesViewModel>()..load(),
                  child: PopScope(
                    onPopInvokedWithResult: (didPop, result) {
                      if (didPop && !home.isDisposed) home.refresh();
                    },
                    child: const CategoriesScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              name: Routes.ADD_EXPENSE,
              path: 'add',
              builder: (context, state) => _expenseForm(context),
            ),
            GoRoute(
              name: Routes.EDIT_EXPENSE,
              path: ':expenseId/edit',
              redirect: (_, state) {
                final id = int.tryParse(
                  state.pathParameters['expenseId'] ?? '',
                );
                return id == null || id <= 0 ? Routes.EXPENSES : null;
              },
              builder: (context, state) => _expenseForm(
                context,
                transactionId: int.parse(state.pathParameters['expenseId']!),
              ),
            ),
            GoRoute(
              name: Routes.PREFERENCES,
              path: 'preferences',
              builder: (context, state) {
                final preferences = context.read<UserPreferencesViewModel>();
                return PopScope(
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) preferences.discardChanges();
                  },
                  child: UserPreferencesScreen(onSaved: (_) => context.pop()),
                );
              },
            ),
          ],
        ),
      ],
    ),
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

  static Widget _expenseForm(BuildContext context, {int? transactionId}) {
    final home = context.read<ExpenseHomeViewModel>();
    return ChangeNotifierProvider(
      key: ValueKey(transactionId),
      create: (_) => getIt<ExpenseFormViewModel>(
        param1: transactionId,
        param2: context
            .read<UserPreferencesViewModel>()
            .savedPreferences!
            .currency
            .code,
      )..load(),
      child: ExpenseFormScreen(
        onSaved: home.refresh,
        onManageCategories: () async {
          await context.pushNamed(Routes.CATEGORIES);
        },
      ),
    );
  }

  /// The app owns this router; no global router or view model is retained here.
  static GoRouter createRouter({String? initialLocation}) => GoRouter(
    // Preserve platform deep links while using the template's default page.
    initialLocation: initialLocation ?? INITIAL,
    routes: routes,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.pageNotFound)),
      body: Center(
        child: FilledButton(
          onPressed: () => context.go(Routes.EXPENSES),
          child: Text(context.l10n.expenseGoHome),
        ),
      ),
    ),
  );
}
