import 'package:customer/domain/cart/entities/cart_list/cart_response_entity.dart';
import 'cart_data_model.dart';

class CartResponseModel extends CartResponseEntity {
  const CartResponseModel({
    required super.status,
    required super.cartData,
    required super.msg,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      status: json['status'] ?? 0,
      cartData: (json['cart_data'] as List<dynamic>?)
              ?.map((e) => CartDataModel.fromJson(e))
              .toList() ??
          [],
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'cart_data': cartData.map((e) => (e as CartDataModel).toJson()).toList(),
      'msg': msg,
    };
  }
}
