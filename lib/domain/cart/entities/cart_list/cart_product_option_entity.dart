import 'package:equatable/equatable.dart';

class CartProductOptionEntity extends Equatable {
  final int id;
  final String name;
  final double price;
  final int isDiscountedPrd;
  final double slashPrice;
  final String unit;
  final int isTaxable;
  final int cgst;
  final int sgst;
  final int cess;
  final String image;
  final int quantity;

  const CartProductOptionEntity({
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
    required this.quantity,
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
        quantity,
      ];
}