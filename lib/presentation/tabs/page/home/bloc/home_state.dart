part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  failure,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;
  final List<ShopListModel>? shopList;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.shopList,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<ShopListModel>? shopList,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shopList: shopList ?? this.shopList,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        shopList ?? '',
      ];
}
