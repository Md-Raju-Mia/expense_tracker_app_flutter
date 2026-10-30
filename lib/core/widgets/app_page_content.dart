import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// Standard single-column layout, used inside a Scaffold/SafeArea.
/// Set scrollable to false when the child owns scrolling (ListView, etc.).
class AppPageContent extends StatelessWidget {
  const AppPageContent({
    required this.child,
    this.scrollable = true,
    this.alignment = Alignment.topCenter,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.maxWidth = AppLayout.contentMaxWidth,
    super.key,
  });

  final Widget child;
  final bool scrollable;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(
        width: double.infinity,
        child: scrollable
            ? SingleChildScrollView(padding: padding, child: child)
            : Padding(padding: padding, child: child),
      ),
    ),
  );
}
