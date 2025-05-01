part of 'cart_list_bloc.dart';

sealed class CartListEvent extends Equatable {
  const CartListEvent();

  @override
  List<Object> get props => [];
}

final class GetCartListEvent extends CartListEvent {}

final class UpdateCartListEvent extends CartListEvent {
  final CartResponseModel cartList;

  const UpdateCartListEvent({required this.cartList});

  @override
  List<Object> get props => [cartList];
}
