import 'dart:async';

class CartRefreshService {
  static final CartRefreshService _instance = CartRefreshService._internal();
  factory CartRefreshService() => _instance;
  CartRefreshService._internal();

  final _refreshController = StreamController<void>.broadcast();

  Stream<void> get refreshStream => _refreshController.stream;

  void refreshCart() {
    _refreshController.add(null);
  }

  void dispose() {
    _refreshController.close();
  }
}
