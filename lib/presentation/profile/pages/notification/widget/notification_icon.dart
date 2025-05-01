import 'package:flutter/material.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'svg_helper.dart';

class NotificationIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const NotificationIcon({
    Key? key,
    this.size = 150,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Try to load the SVG
    final svgWidget = SvgHelper.loadSvgAsset(
      'assets/images/bell-dynamic-gradient.svg',
      width: size,
      height: size,
      color: color,
    );

    // If SVG loaded successfully, return it
    if (svgWidget != null) {
      return svgWidget;
    }

    // Otherwise, fallback to a regular icon
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.notifications_outlined,
        size: size * 0.53, // Approximately half the container size
        color: color ?? AppColor.primaryColor,
      ),
    );
  }
}
