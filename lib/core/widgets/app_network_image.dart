import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

typedef AppImageErrorBuilder =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

/// A theme-aware network image with consistent progress and failure states.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.semanticLabel,
    this.loadingBuilder,
    this.errorBuilder,
    super.key,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry borderRadius;
  final String? semanticLabel;
  final WidgetBuilder? loadingBuilder;
  final AppImageErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        if (loadingBuilder != null) return loadingBuilder!(context);
        final expected = progress.expectedTotalBytes;
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(
                value: expected == null
                    ? null
                    : progress.cumulativeBytesLoaded / expected,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (errorBuilder != null) {
          return errorBuilder!(context, error, stackTrace);
        }
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              semanticLabel: semanticLabel,
            ),
          ),
        );
      },
    ),
  );
}
