import 'package:customer/domain/favourites_product_list/entities/fav_product_entity.dart';

class FavProductModel extends FavProductEntity {
  const FavProductModel({
    required super.id,
    required super.name,
    required super.prdTagName,
    required super.description,
    required super.price,
    required super.isDiscountedPrd,
    required super.slashPrice,
    required super.image,
    required super.prdAvgRating,
    required super.prdTotalCount,
    required super.prdFoodType,
  });

  factory FavProductModel.fromJson(Map<String, dynamic> json) {
    return FavProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      prdTagName: json['prd_tag_name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      isDiscountedPrd: json['is_discounted_prd'] ?? 0,
      slashPrice: json['slash_price'] ?? '0.00',
      image: json['image'] ?? '',
      prdAvgRating: json['prd_avg_rating'] ?? 0,
      prdTotalCount: json['prd_total_count'] ?? '0',
      prdFoodType: json['prd_food_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prd_tag_name': prdTagName,
      'description': description,
      'price': price,
      'is_discounted_prd': isDiscountedPrd,
      'slash_price': slashPrice,
      'image': image,
      'prd_avg_rating': prdAvgRating,
      'prd_total_count': prdTotalCount,
      'prd_food_type': prdFoodType,
    };
  }
}
