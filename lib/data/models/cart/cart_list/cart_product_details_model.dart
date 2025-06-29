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
    // required super.unpackagePrdPrice,
    required super.status,
    required super.unpackagePrdQty,
  });

  factory CartProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return CartProductDetailsModel(
      id: json['id'] ?? 0,
      productCategoryId: json['product_category_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['prd_price'] is int)
          ? (json['prd_price'] as int).toDouble()
          : (json['prd_price'] is double)
              ? json['prd_price']
              : double.tryParse(json['prd_price'].toString()) ?? 0.0,
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: (json['prd_slash_price'] ?? 0).toDouble(),
      unit: (json['unit'] ?? '').toString(),
      isTaxable: json['is_taxable'] ?? 0,
      cgst: (json['cgst'] is int)
          ? (json['cgst'] as int).toDouble()
          : (json['cgst'] is double)
              ? json['cgst']
              : double.tryParse(json['cgst'].toString()) ?? 0.0,
      sgst: (json['sgst'] is int)
          ? (json['sgst'] as int).toDouble()
          : (json['sgst'] is double)
              ? json['sgst']
              : double.tryParse(json['sgst'].toString()) ?? 0.0,
      cess: (json['cess'] is int)
          ? (json['cess'] as int).toDouble()
          : (json['cess'] is double)
              ? json['cess']
              : double.tryParse(json['cess'].toString()) ?? 0.0,
      image: json['image'] ?? '',
      stockStatus: json['stock_status'] ?? false,
      qty: json['qty'] ?? 0,
      isUnpackagePrd: json['is_unpackage_prd'] ?? 0,
      unpackagePrdUnit: json['unpackage_prd_unit'] ?? '',
      // unpackagePrdPrice: json['unpackage_prd_price'] ?? '0.00',
      status: json['status'] ?? false,
      unpackagePrdQty: json['unpackage_prd_qty'] ?? 0,
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
      // 'unpackage_prd_price': unpackagePrdPrice,
      'status': status,
      'unpackage_prd_qty': unpackagePrdQty,
    };
  }
}
