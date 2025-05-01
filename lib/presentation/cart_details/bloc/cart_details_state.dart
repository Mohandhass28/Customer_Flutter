part of 'cart_details_bloc.dart';

enum CartDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class CartDetailsState extends Equatable {
  final CartDetailsStatus status;
  final String? errorMessage;
  final AddToCartSuccessResponseModel? modifyCartResponse;

  const CartDetailsState({
    this.status = CartDetailsStatus.initial,
    this.errorMessage,
    this.modifyCartResponse,
  });

  CartDetailsState copyWith({
    CartDetailsStatus? status,
    String? errorMessage,
    AddToCartSuccessResponseModel? modifyCartResponse,
  }) {
    return CartDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      modifyCartResponse: modifyCartResponse ?? this.modifyCartResponse,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        modifyCartResponse ?? '',
      ];
}
