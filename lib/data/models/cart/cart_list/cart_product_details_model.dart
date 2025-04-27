import 'package:customer/domain/cart/entities/cart_list/cart_product_details_entity.dart';

class CartProductDetailsModel extends CartProductDetailsEntity {
  const CartProductDetailsModel({
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
    required super.isUnpackagePrd,
    required super.unpackagePrdUnit,
    required super.unpackagePrdPrice,
    required super.status,
    required super.unpackagePrdQty,
  });

  factory CartProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return CartProductDetailsModel(
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
      isUnpackagePrd: json['is_unpackage_prd'] ?? 0,
      unpackagePrdUnit: json['unpackage_prd_unit'] ?? '',
      unpackagePrdPrice: json['unpackage_prd_price'] ?? '0.00',
      status: json['status'] ?? false,
      unpackagePrdQty: json['unpackage_prd_qty'] ?? '0.00',
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
      'is_unpackage_prd': isUnpackagePrd,
      'unpackage_prd_unit': unpackagePrdUnit,
      'unpackage_prd_price': unpackagePrdPrice,
      'status': status,
      'unpackage_prd_qty': unpackagePrdQty,
    };
  }
}
