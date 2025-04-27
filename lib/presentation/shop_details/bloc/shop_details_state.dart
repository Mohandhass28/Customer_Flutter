part of 'shop_details_bloc.dart';

enum ShopDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class ShopDetailsState extends Equatable {
  final ShopDetailsStatus status;
  final String? errorMessage;
  final ShopDetailsResponseModel? shopDetails;

  const ShopDetailsState({
    this.status = ShopDetailsStatus.initial,
    this.errorMessage,
    this.shopDetails,
  });

  ShopDetailsState copyWith({
    ShopDetailsStatus? status,
    String? errorMessage,
    ShopDetailsResponseModel? shopDetails,
  }) {
    return ShopDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shopDetails: shopDetails ?? this.shopDetails,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        shopDetails ?? '',
      ];
}
