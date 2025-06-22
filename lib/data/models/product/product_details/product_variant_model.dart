import 'package:customer/domain/product/entities/product_details/product_variant_entity.dart';

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.id,
    required super.productId,
    required super.price,
    required super.unit,
    required super.image,
    required super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.variantId,
    required super.isDiscountedPrd,
    required super.slashPrice,
    required super.qty,
    super.variantName,
    required super.status,
    super.productFoodType,
    required super.isUnpackagePrd,
    super.unpackagePrdUnit,
    super.unpackagePrdPrice,
    required super.actual_product_id,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      price: json['price'] ?? '0.00',
      unit: json['unit'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      variantId: json['variant_id'],
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: json['slash_price'] ?? '0.00',
      qty: json['qty'] ?? 0,
      variantName: json['variant_name'],
      status: json['status'] ?? 0,
      productFoodType: json['product_food_type'],
      isUnpackagePrd: json['is_unpackage_prd'] ?? 0,
      unpackagePrdUnit: json['unpackage_prd_unit'],
      unpackagePrdPrice: json['unpackage_prd_price'],
      actual_product_id: json['actual_product_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'price': price,
      'unit': unit,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'variant_id': variantId,
      'is_discounted_prd': isDiscountedPrd,
      'slash_price': slashPrice,
      'qty': qty,
      'variant_name': variantName,
      'status': status,
      'product_food_type': productFoodType,
      'is_unpackage_prd': isUnpackagePrd,
      'unpackage_prd_unit': unpackagePrdUnit,
      'unpackage_prd_price': unpackagePrdPrice,
      'actual_product_id': actual_product_id,
    };
  }
}
