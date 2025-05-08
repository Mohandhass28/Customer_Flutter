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
  final ShopListResponseModel? shopList;
  final FavProductListResponseModel? favProductList;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.shopList,
    this.favProductList,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    ShopListResponseModel? shopList,
    FavProductListResponseModel? favProductList,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shopList: shopList ?? this.shopList,
      favProductList: favProductList ?? this.favProductList,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        shopList ?? '',
        favProductList ?? '',
      ];
}
