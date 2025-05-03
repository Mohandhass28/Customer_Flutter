part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final ProductDetailsParams params;
  const GetProductDetailsEvent({required this.params});

  @override
  List<Object> get props => [];
}

class UpdateTotalPriceEvent extends ProductDetailsEvent {
  final double totalPrice;

  const UpdateTotalPriceEvent({required this.totalPrice});

  @override
  List<Object> get props => [totalPrice];
}

class WishProductListEvent extends ProductDetailsEvent {
  final int productId;
  final int isWishlist;
  const WishProductListEvent(
      {required this.productId, required this.isWishlist});

  @override
  List<Object> get props => [];
}
