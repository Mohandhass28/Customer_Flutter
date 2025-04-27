import 'package:equatable/equatable.dart';

class CartProductVariantEntity extends Equatable {
  final int id;
  final int productId;
  final double price;
  final String unit;
  final String image;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? variantId;
  final int isDiscountedPrd;
  final double slashPrice;
  final int qty;
  final String variantName;
  final int status;
  final String? productFoodType;
  final int isUnpackagePrd;
  final String? unpackagePrdUnit;
  final String? unpackagePrdPrice;
  final int quantity;

  const CartProductVariantEntity({
    required this.id,
    required this.productId,
    required this.price,
    required this.unit,
    required this.image,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.variantId,
    required this.isDiscountedPrd,
    required this.slashPrice,
    required this.qty,
    required this.variantName,
    required this.status,
    this.productFoodType,
    required this.isUnpackagePrd,
    this.unpackagePrdUnit,
    this.unpackagePrdPrice,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        price,
        unit,
        image,
        createdAt,
        updatedAt,
        deletedAt,
        variantId,
        isDiscountedPrd,
        slashPrice,
        qty,
        variantName,
        status,
        productFoodType,
        isUnpackagePrd,
        unpackagePrdUnit,
        unpackagePrdPrice,
        quantity,
      ];
}