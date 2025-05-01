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
    super.product_id,
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
      product_id: json['product_id'] ?? 0,
    );
  }

  CartProductOptionModel copyWith({
    int? id,
    String? name,
    double? price,
    int? isDiscountedPrd,
    double? slashPrice,
    String? unit,
    int? isTaxable,
    int? cgst,
    int? sgst,
    int? cess,
    String? image,
    int? quantity,
    int? product_id,
  }) {
    return CartProductOptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isDiscountedPrd: isDiscountedPrd ?? this.isDiscountedPrd,
      slashPrice: slashPrice ?? this.slashPrice,
      unit: unit ?? this.unit,
      isTaxable: isTaxable ?? this.isTaxable,
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
      cess: cess ?? this.cess,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      product_id: product_id ?? this.product_id,
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
      'product_id': product_id,
    };
  }
}
