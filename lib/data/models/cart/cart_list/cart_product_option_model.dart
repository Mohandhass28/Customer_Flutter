import 'package:customer/domain/cart/entities/cart_list/cart_product_option_entity.dart';

class CartProductOptionModel extends CartProductOptionEntity {
  const CartProductOptionModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isDiscountedPrd,
    required super.slashPrice,
    required super.unit,
    required super.isTaxable,
    required super.cgst,
    required super.sgst,
    required super.cess,
    required super.image,
    required super.quantity,
  });

  factory CartProductOptionModel.fromJson(Map<String, dynamic> json) {
    return CartProductOptionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: (json['slash_price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      isTaxable: json['is_taxable'] ?? 0,
      cgst: json['cgst'] ?? 0,
      sgst: json['sgst'] ?? 0,
      cess: json['cess'] ?? 0,
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'is_discounted_prd': isDiscountedPrd,
      'slash_price': slashPrice,
      'unit': unit,
      'is_taxable': isTaxable,
      'cgst': cgst,
      'sgst': sgst,
      'cess': cess,
      'image': image,
      'quantity': quantity,
    };
  }
}
