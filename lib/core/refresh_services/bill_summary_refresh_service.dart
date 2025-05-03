import 'dart:async';

class BillSummaryRefreshService {
  static final BillSummaryRefreshService _instance =
      BillSummaryRefreshService._internal();
  factory BillSummaryRefreshService() => _instance;
  BillSummaryRefreshService._internal();

  final _refreshController = StreamController<void>.broadcast();

  Stream<void> get refreshStream => _refreshController.stream;

  void refreshBillSummary() {
    _refreshController.add(null);
  }

  void dispose() {
    _refreshController.close();
  }
}
