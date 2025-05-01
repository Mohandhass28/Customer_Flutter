import 'package:customer/domain/cart/entities/cart_details/cart_details_entity.dart';
import 'package:equatable/equatable.dart';
import 'cart_product_entity.dart';

class CartDetailsResponseEntity extends Equatable {
  final int status;
  final CartDetailsEntity cartDetails;
  final List<CartDetailsProductEntity> productDetails;
  final String msg;

  const CartDetailsResponseEntity({
    required this.status,
    required this.cartDetails,
    required this.productDetails,
    required this.msg,
  });

  @override
  List<Object?> get props => [
        status,
        cartDetails,
        productDetails,
        msg,
      ];
}
