import 'package:customer/domain/cart/entities/cart_list/cart_data_entity.dart';
import 'package:equatable/equatable.dart';

class CartResponseEntity extends Equatable {
  final int status;
  final List<CartDataEntity> cartData;
  final String msg;

  const CartResponseEntity({
    required this.status,
    required this.cartData,
    required this.msg,
  });

  @override
  List<Object?> get props => [status, cartData, msg];
}
