part of 'product_details_bloc.dart';

enum ProductDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final String? errorMessage;
  final ProductDetailsResponseModel? productDetails;
  final double totalPrice;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.errorMessage,
    this.productDetails,
    this.totalPrice = 0.0,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    String? errorMessage,
    ProductDetailsResponseModel? productDetails,
    double? totalPrice,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      productDetails: productDetails ?? this.productDetails,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        productDetails ?? '',
        totalPrice,
      ];
}
