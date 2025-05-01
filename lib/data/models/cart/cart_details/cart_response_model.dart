import 'package:customer/domain/cart/entities/cart_details/cart_response_entity.dart';
import 'cart_details_model.dart';
import 'cart_product_model.dart';

class CartDetailsResponseModel extends CartDetailsResponseEntity {
  const CartDetailsResponseModel({
    required super.status,
    required super.cartDetails,
    required super.productDetails,
    required super.msg,
  });

  factory CartDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return CartDetailsResponseModel(
      status: json['status'] ?? 0,
      cartDetails: CartDetailsModel.fromJson(json['cart_details'] ?? {}),
      productDetails: (json['product_details'] as List<dynamic>?)
              ?.map((e) => CartDetailsProductModel.fromJson(e))
              .toList() ??
          [],
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'cart_details': (cartDetails as CartDetailsModel).toJson(),
      'product_details': productDetails
          .map((e) => (e as CartDetailsProductModel).toJson())
          .toList(),
      'msg': msg,
    };
  }
}
