part of 'cart_details_bloc.dart';

sealed class CartDetailsEvent extends Equatable {
  const CartDetailsEvent();

  @override
  List<Object> get props => [];
}

class ModifyCartEvent extends CartDetailsEvent {
  final AddToCartParams params;

  const ModifyCartEvent({required this.params});

  @override
  List<Object> get props => [
        params,
      ];
}
