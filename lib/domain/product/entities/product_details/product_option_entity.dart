import 'package:equatable/equatable.dart';

class ProductOptionEntity extends Equatable {
  final int id;
  final String name;
  final String price;
  final int isDiscountedPrd;
  final String slashPrice;
  final String unit;
  final int isTaxable;
  final int cgst;
  final int sgst;
  final int cess;
  final String image;

  const ProductOptionEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.isDiscountedPrd,
    required this.slashPrice,
    required this.unit,
    required this.isTaxable,
    required this.cgst,
    required this.sgst,
    required this.cess,
    required this.image,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        isDiscountedPrd,
        slashPrice,
        unit,
        isTaxable,
        cgst,
        sgst,
        cess,
        image,
      ];
}
