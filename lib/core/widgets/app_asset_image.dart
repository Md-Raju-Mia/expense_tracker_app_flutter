import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_network_image.dart';

/// Renders raster and SVG assets through one small, path-based API.
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
    this.placeholderBuilder,
    this.errorBuilder,
    super.key,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String? semanticLabel;
  final WidgetBuilder? placeholderBuilder;
  final AppImageErrorBuilder? errorBuilder;

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        semanticsLabel: semanticLabel,
        placeholderBuilder: placeholderBuilder,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
        errorBuilder: errorBuilder,
      );
    }
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      semanticLabel: semanticLabel,
      errorBuilder: errorBuilder,
    );
  }
}
