import 'package:flutter/material.dart';

/// Theme-driven dialog content that preserves Material action layout behavior.
class AppDialog extends StatelessWidget {
  const AppDialog({
    this.icon,
    this.title,
    this.content,
    this.actions = const [],
    super.key,
  });

  final Widget? icon;
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => AlertDialog(
    icon: icon,
    title: title,
    content: content,
    actions: actions,
    scrollable: true,
  );
}

Future<T?> showAppDialog<T>(
  BuildContext context, {
  Widget? icon,
  Widget? title,
  Widget? content,
  List<Widget> actions = const [],
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) => showDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  useRootNavigator: useRootNavigator,
  routeSettings: routeSettings,
  builder: (_) =>
      AppDialog(icon: icon, title: title, content: content, actions: actions),
);
