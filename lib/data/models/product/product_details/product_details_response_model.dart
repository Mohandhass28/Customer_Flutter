import 'package:customer/domain/product/entities/product_details/product_details_response_entity.dart';
import 'product_data_model.dart';

class ProductDetailsResponseModel extends ProductDetailsResponseEntity {
  const ProductDetailsResponseModel({
    required super.status,
    required super.productData,
    required super.msg,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModel(
      status: json['status'] ?? 0,
      productData: ProductDataModel.fromJson(json['product_data'] ?? {}),
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'product_data': (productData as ProductDataModel).toJson(),
      'msg': msg,
    };
  }
}
