# customer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

for analyze size:
flutter build apk --target-platform android-arm64 --analyze-size

for android build:
flutter build apk

for ios build:
flutter build ios

for web build:
flutter build web

for windows build:
flutter build windows

for macos build:
flutter build macos

for linux build:
flutter build linux

## Performance Optimization Tips

To improve app performance, especially in simulators:

1. **Run in Release Mode**:

   ```
   flutter run --release
   ```

2. **Optimize Images**:

   - Use `cacheWidth` and `cacheHeight` parameters with Image.network
   - Implement proper loading and error states
   - Consider using cached_network_image package

3. **Reduce Rebuilds**:

   - Extract widgets into smaller components
   - Use const constructors where possible
   - Implement shouldRebuild in custom widgets

4. **Optimize Lists**:

   - Use ListView.builder instead of Column with many children
   - Set shrinkWrap: true and physics: NeverScrollableScrollPhysics for nested lists
   - Filter data before building lists

5. **Debug Performance**:

   - Use Flutter DevTools to profile your app
   - Check for jank with the Timeline view
   - Monitor memory usage

6. **Simulator-Specific Tips**:

   - Reduce animations in simulator
   - Close other resource-intensive apps
   - Increase simulator memory (if possible)
   - Test on real devices for accurate performance

7. **Network Optimization**:

   - Implement proper caching
   - Reduce unnecessary API calls
   - Use pagination for large data sets

8. **Remove Debug Prints**:
   - Remove all debug prints in release builds
   - Use proper logging libraries for debugging
