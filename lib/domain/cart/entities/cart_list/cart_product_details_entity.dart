import 'package:equatable/equatable.dart';

class CartProductDetailsEntity extends Equatable {
  final int id;
  final int productCategoryId;
  final String name;
  final String description;
  final double price;
  final int isDiscountedPrd;
  final double slashPrice;
  final String unit;
  final int isTaxable;
  final String cgst;
  final String sgst;
  final String cess;
  final String image;
  final bool stockStatus;
  final String qty;
  final int isUnpackagePrd;
  final String unpackagePrdUnit;
  final String unpackagePrdPrice;
  final bool status;
  final String unpackagePrdQty;

  const CartProductDetailsEntity({
    required this.id,
    required this.productCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.isDiscountedPrd,
    required this.slashPrice,
    required this.unit,
    required this.isTaxable,
    required this.cgst,
    required this.sgst,
    required this.cess,
    required this.image,
    required this.stockStatus,
    required this.qty,
    required this.isUnpackagePrd,
    required this.unpackagePrdUnit,
    required this.unpackagePrdPrice,
    required this.status,
    required this.unpackagePrdQty,
  });

  @override
  List<Object?> get props => [
        id,
        productCategoryId,
        name,
        description,
        price,
        isDiscountedPrd,
        slashPrice,
        unit,
        isTaxable,
        cgst,
        sgst,
        cess,
        image,
        stockStatus,
        qty,
        isUnpackagePrd,
        unpackagePrdUnit,
        unpackagePrdPrice,
        status,
        unpackagePrdQty,
      ];
}