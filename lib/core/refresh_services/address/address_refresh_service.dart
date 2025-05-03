import 'dart:async';

class AddressRefreshService {
  static final AddressRefreshService _instance =
      AddressRefreshService._internal();
  factory AddressRefreshService() => _instance;
  AddressRefreshService._internal();

  final _refreshController = StreamController<void>.broadcast();

  Stream<void> get refreshStream => _refreshController.stream;

  void refreshAddress() {
    _refreshController.add(null);
  }

  void dispose() {
    _refreshController.close();
  }
}
