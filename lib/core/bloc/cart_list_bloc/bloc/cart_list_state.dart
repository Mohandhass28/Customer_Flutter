part of 'cart_list_bloc.dart';

enum CartListStatus {
  initial,
  loading,
  success,
  failure,
}

class CartListState extends Equatable {
  final CartListStatus status;
  final String? errorMessage;
  final CartResponseModel? cartList;

  const CartListState({
    this.status = CartListStatus.initial,
    this.errorMessage,
    this.cartList,
  });

  CartListState copyWith({
    CartListStatus? status,
    String? errorMessage,
    CartResponseModel? cartList,
  }) {
    return CartListState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      cartList: cartList ?? this.cartList,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        cartList ?? '',
        cartList?.cartData ?? '',
        cartList?.cartData.length ?? '',
        cartList?.cartData.isNotEmpty ?? '',
      ];
}
