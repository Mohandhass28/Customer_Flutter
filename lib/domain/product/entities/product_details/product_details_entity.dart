import 'package:equatable/equatable.dart';

class ProductDetailsEntity extends Equatable {
  final int id;
  final int shopId;
  final int productCategoryId;
  final String name;
  final String description;
  final String price;
  final String unit;
  final int isTaxable;
  final String cgst;
  final String sgst;
  final String cess;
  final String image;
  final bool status;
  final bool stockStatus;
  final int isBestSeller;
  final int isFeatured;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String qty;
  final int isDiscountedPrd;
  final String slashPrice;
  final int isUnpackagePrd;
  final String unpackagePrdPrice;
  final String unpackagePrdUnit;
  final int deliveryMode;
  final int prdCoverBy;
  final int prdCoverNum;
  final int prdCoverDuration;
  final String? productFoodType;

  const ProductDetailsEntity({
    required this.id,
    required this.shopId,
    required this.productCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.isTaxable,
    required this.cgst,
    required this.sgst,
    required this.cess,
    required this.image,
    required this.status,
    required this.stockStatus,
    required this.isBestSeller,
    required this.isFeatured,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.qty,
    required this.isDiscountedPrd,
    required this.slashPrice,
    required this.isUnpackagePrd,
    required this.unpackagePrdPrice,
    required this.unpackagePrdUnit,
    required this.deliveryMode,
    required this.prdCoverBy,
    required this.prdCoverNum,
    required this.prdCoverDuration,
    this.productFoodType,
  });

  @override
  List<Object?> get props => [
        id,
        shopId,
        productCategoryId,
        name,
        description,
        price,
        unit,
        isTaxable,
        cgst,
        sgst,
        cess,
        image,
        status,
        stockStatus,
        isBestSeller,
        isFeatured,
        createdAt,
        updatedAt,
        deletedAt,
        qty,
        isDiscountedPrd,
        slashPrice,
        isUnpackagePrd,
        unpackagePrdPrice,
        unpackagePrdUnit,
        deliveryMode,
        prdCoverBy,
        prdCoverNum,
        prdCoverDuration,
        productFoodType,
      ];
}
