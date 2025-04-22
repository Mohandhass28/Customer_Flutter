import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This class provides navigation methods using GoRouter
/// It's a wrapper around GoRouter to make navigation easier
class AppNavigation {
  /// Navigate to a new route, replacing the current one
  static void pushReplacement(BuildContext context, String path,
      {Object? extra}) {
    context.go(path, extra: extra);
  }

  /// Navigate to a new route
  static void push(BuildContext context, String path, {Object? extra}) {
    context.go(path, extra: extra);
  }

  /// Navigate to a new route, removing all previous routes
  static void pushAndRemove(BuildContext context, String path,
      {Object? extra}) {
    context.go(path, extra: extra);
  }
}
