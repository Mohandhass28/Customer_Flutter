part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetShopListEvent extends HomeEvent {
  final ShopListParams params;
  const GetShopListEvent({required this.params});

  @override
  List<Object> get props => [];
}

class AddRemoveShopWishlist extends HomeEvent {
  final int shopId;
  final int isWishlist;
  const AddRemoveShopWishlist({required this.shopId, required this.isWishlist});

  @override
  List<Object> get props => [];
}

class GetFavProductListEvent extends HomeEvent {
  const GetFavProductListEvent();

  @override
  List<Object> get props => [];
}
