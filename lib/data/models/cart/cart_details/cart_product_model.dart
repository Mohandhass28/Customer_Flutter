import 'package:customer/domain/cart/entities/cart_details/cart_product_entity.dart';
import 'cart_variant_model.dart';

class CartDetailsProductModel extends CartDetailsProductEntity {
  const CartDetailsProductModel({
    required super.id,
    required super.productCategoryId,
    required super.name,
    required super.description,
    required super.price,
    required super.isDiscountedPrd,
    required super.slashPrice,
    required super.unit,
    required super.isTaxable,
    required super.cgst,
    required super.sgst,
    required super.cess,
    required super.image,
    required super.stockStatus,
    required super.qty,
    required super.status,
    required super.imageList,
    required super.variantList,
    required super.optionList,
  });

  factory CartDetailsProductModel.fromJson(Map<String, dynamic> json) {
    return CartDetailsProductModel(
      id: json['id'] ?? 0,
      productCategoryId: json['product_category_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: (json['slash_price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      isTaxable: json['is_taxable'] ?? 0,
      cgst: json['cgst'] ?? '0.00',
      sgst: json['sgst'] ?? '0.00',
      cess: json['cess'] ?? '0.00',
      image: json['image'] ?? '',
      stockStatus: json['stock_status'] ?? false,
      qty: json['qty'] ?? '0',
      status: json['status'] ?? false,
      imageList: List<String>.from(json['imageList'] ?? []),
      variantList: (json['variantList'] as List<dynamic>?)
              ?.map((e) => CartDetailsVariantModel.fromJson(e))
              .toList() ??
          [],
      optionList: json['optionList'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_category_id': productCategoryId,
      'name': name,
      'description': description,
      'price': price,
      'is_discounted_prd': isDiscountedPrd,
      'slash_price': slashPrice,
      'unit': unit,
      'is_taxable': isTaxable,
      'cgst': cgst,
      'sgst': sgst,
      'cess': cess,
      'image': image,
      'stock_status': stockStatus,
      'qty': qty,
      'status': status,
      'imageList': imageList,
      'variantList': variantList
          .map((e) => (e as CartDetailsVariantModel).toJson())
          .toList(),
      'optionList': optionList,
    };
  }
}
