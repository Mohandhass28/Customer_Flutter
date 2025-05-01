import 'package:equatable/equatable.dart';

class CartDetailsVariantEntity extends Equatable {
  final int id;
  final String variantName;
  final double price;
  final int isDiscountedPrd;
  final double slashPrice;
  final String unit;
  final String image;
  final int quantity;

  const CartDetailsVariantEntity({
    required this.id,
    required this.variantName,
    required this.price,
    required this.isDiscountedPrd,
    required this.slashPrice,
    required this.unit,
    required this.image,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
        id,
        variantName,
        price,
        isDiscountedPrd,
        slashPrice,
        unit,
        image,
        quantity,
      ];
}
