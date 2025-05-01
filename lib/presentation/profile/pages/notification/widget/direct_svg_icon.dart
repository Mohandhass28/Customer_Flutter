import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:customer/core/config/theme/app_color.dart';

class DirectSvgIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const DirectSvgIcon({
    super.key,
    this.size = 150,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Use asset path instead of file path for cross-platform compatibility
    const String assetPath = 'assets/images/bell-dynamic-gradient.svg';

    try {
      return SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } catch (e) {
      debugPrint('Error loading SVG asset: $e');
    }

    // Fallback to a regular icon
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.notifications_outlined,
        size: size * 0.53,
        color: color ?? AppColor.primaryColor,
      ),
    );
  }
}
