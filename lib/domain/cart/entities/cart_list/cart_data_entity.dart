import 'package:customer/domain/cart/entities/cart_list/cart_product_details_entity.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_product_option_entity.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_product_variant_entity.dart';
import 'package:equatable/equatable.dart';

class CartDataEntity extends Equatable {
  final int id;
  final String quantity;
  final CartProductDetailsEntity productDetails;
  final List<dynamic> productImages;
  final List<CartProductVariantEntity> productVariant;
  final List<CartProductOptionEntity> productOptions;
  final String prdTagName;

  const CartDataEntity({
    required this.id,
    required this.quantity,
    required this.productDetails,
    required this.productImages,
    required this.productVariant,
    required this.productOptions,
    required this.prdTagName,
  });

  @override
  List<Object?> get props => [
        id,
        quantity,
        productDetails,
        productImages,
        productVariant,
        productOptions,
        prdTagName,
      ];
}
