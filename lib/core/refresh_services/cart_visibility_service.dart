import 'dart:async';

/// A service to manage the visibility of the bottom cart
/// This service is used to hide/show the bottom cart when the add to cart bottom sheet is opened/closed
class CartVisibilityService {
  static final CartVisibilityService _instance = CartVisibilityService._internal();
  factory CartVisibilityService() => _instance;
  CartVisibilityService._internal();

  final _hideCartController = StreamController<void>.broadcast();
  final _showCartController = StreamController<void>.broadcast();

  Stream<void> get hideCartStream => _hideCartController.stream;
  Stream<void> get showCartStream => _showCartController.stream;

  void hideCart() {
    _hideCartController.add(null);
  }

  void showCart() {
    _showCartController.add(null);
  }

  void dispose() {
    _hideCartController.close();
    _showCartController.close();
  }
}
