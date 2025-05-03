import 'package:equatable/equatable.dart';

class ShopListEntity extends Equatable {
  final int id;
  final String shopName;
  final String logo;
  final String bannerImage;
  final String latitude;
  final String longitude;
  final double distance;
  final String distanceIn;
  final String deliveryTime;
  final int isWishlist;
  final double avgRating;
  final String totalCount;
  final List<dynamic> productCategory;
  final bool shopStatus;
  final int productCount;

  const ShopListEntity({
    required this.id,
    required this.shopName,
    required this.logo,
    required this.bannerImage,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.distanceIn,
    required this.deliveryTime,
    required this.isWishlist,
    required this.avgRating,
    required this.totalCount,
    required this.productCategory,
    required this.shopStatus,
    required this.productCount,
  });

  @override
  List<Object?> get props => [
        id,
        shopName,
        logo,
        bannerImage,
        latitude,
        longitude,
        distance,
        distanceIn,
        deliveryTime,
        isWishlist,
        avgRating,
        totalCount,
        productCategory,
        shopStatus,
        productCount,
      ];
}
