import 'package:equatable/equatable.dart';
import 'cart_variant_entity.dart';

class CartDetailsProductEntity extends Equatable {
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
  final bool status;
  final List<Map<String, dynamic>> imageList;
  final List<CartDetailsVariantEntity> variantList;
  final List<dynamic> optionList;

  const CartDetailsProductEntity({
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
    required this.status,
    required this.imageList,
    required this.variantList,
    required this.optionList,
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
        status,
        imageList,
        variantList,
        optionList,
      ];
}
