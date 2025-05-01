import 'package:customer/domain/cart/entities/cart_details/cart_variant_entity.dart';

class CartDetailsVariantModel extends CartDetailsVariantEntity {
  const CartDetailsVariantModel({
    required super.id,
    required super.variantName,
    required super.price,
    required super.isDiscountedPrd,
    required super.slashPrice,
    required super.unit,
    required super.image,
    required super.quantity,
  });

  factory CartDetailsVariantModel.fromJson(Map<String, dynamic> json) {
    return CartDetailsVariantModel(
      id: json['id'] ?? 0,
      variantName: json['variant_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: (json['slash_price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_name': variantName,
      'price': price,
      'is_discounted_prd': isDiscountedPrd,
      'slash_price': slashPrice,
      'unit': unit,
      'image': image,
      'quantity': quantity,
    };
  }
}
