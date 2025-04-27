import 'package:customer/domain/cart/entities/cart_list/cart_data_entity.dart';
import 'cart_product_details_model.dart';
import 'cart_product_variant_model.dart';
import 'cart_product_option_model.dart';

class CartDataModel extends CartDataEntity {
  const CartDataModel({
    required super.id,
    required super.quantity,
    required super.productDetails,
    required super.productImages,
    required super.productVariant,
    required super.productOptions,
    required super.prdTagName,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? '0',
      productDetails:
          CartProductDetailsModel.fromJson(json['product_details'] ?? {}),
      productImages: json['product_images'] ?? [],
      productVariant: (json['product_variant'] as List<dynamic>?)
              ?.map((e) => CartProductVariantModel.fromJson(e))
              .toList() ??
          [],
      productOptions: (json['product_options'] as List<dynamic>?)
              ?.map((e) => CartProductOptionModel.fromJson(e))
              .toList() ??
          [],
      prdTagName: json['prd_tag_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product_details': (productDetails as CartProductDetailsModel).toJson(),
      'product_images': productImages,
      'product_variant': productVariant
          .map((e) => (e as CartProductVariantModel).toJson())
          .toList(),
      'product_options': productOptions
          .map((e) => (e as CartProductOptionModel).toJson())
          .toList(),
      'prd_tag_name': prdTagName,
    };
  }
}
