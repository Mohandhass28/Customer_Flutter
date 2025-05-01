part of 'add_to_cart_bloc.dart';

sealed class AddToCartEvent extends Equatable {
  const AddToCartEvent();

  @override
  List<Object> get props => [];
}

class AddItemToCartEvent extends AddToCartEvent {
  final AddToCartParams params;
  const AddItemToCartEvent({required this.params});

  @override
  List<Object> get props => [
        params,
      ];
}
