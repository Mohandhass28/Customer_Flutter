import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgHelper {
  /// Attempts to load an SVG from the assets directory
  /// Returns null if the SVG cannot be loaded
  static Widget? loadSvgAsset(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    try {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    } catch (e) {
      debugPrint('Error loading SVG asset: $e');
      return null;
    }
  }

  /// Attempts to load an SVG from a network URL
  /// Returns null if the SVG cannot be loaded
  static Widget? loadSvgNetwork(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    try {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        fit: fit,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    } catch (e) {
      debugPrint('Error loading SVG from network: $e');
      return null;
    }
  }
}
