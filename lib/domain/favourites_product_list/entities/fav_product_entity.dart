import 'package:equatable/equatable.dart';

class FavProductEntity extends Equatable {
  final int id;
  final String name;
  final String prdTagName;
  final String description;
  final String price;
  final int isDiscountedPrd;
  final String slashPrice;
  final String image;
  final int prdAvgRating;
  final String prdTotalCount;
  final String prdFoodType;

  const FavProductEntity({
    required this.id,
    required this.name,
    required this.prdTagName,
    required this.description,
    required this.price,
    required this.isDiscountedPrd,
    required this.slashPrice,
    required this.image,
    required this.prdAvgRating,
    required this.prdTotalCount,
    required this.prdFoodType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        prdTagName,
        description,
        price,
        isDiscountedPrd,
        slashPrice,
        image,
        prdAvgRating,
        prdTotalCount,
        prdFoodType,
      ];
}