import 'package:customer/domain/product/entities/product_details/product_option_entity.dart';

class ProductOptionModel extends ProductOptionEntity {
  const ProductOptionModel({
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
  });

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) {
    return ProductOptionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '0.00',
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: json['slash_price'] ?? '0.00',
      unit: json['unit'] ?? '',
      isTaxable: json['is_taxable'] ?? 0,
      cgst: json['cgst'] ?? 0,
      sgst: json['sgst'] ?? 0,
      cess: json['cess'] ?? 0,
      image: json['image'] ?? '',
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
    };
  }
}
