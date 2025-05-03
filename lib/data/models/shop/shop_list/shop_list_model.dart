import '../../../../domain/shop/entities/shop_list/shop_list_entity.dart';

class ShopListModel extends ShopListEntity {
  const ShopListModel({
    required super.id,
    required super.shopName,
    required super.logo,
    required super.bannerImage,
    required super.latitude,
    required super.longitude,
    required super.distance,
    required super.distanceIn,
    required super.deliveryTime,
    required super.isWishlist,
    required super.avgRating,
    required super.totalCount,
    required super.productCategory,
    required super.shopStatus,
    required super.productCount,
  });

  factory ShopListModel.fromJson(Map<String, dynamic> json) {
    return ShopListModel(
      id: json['id'] ?? 0,
      shopName: json['shop_name'] ?? '',
      logo: json['logo'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      distance: (json['distance'] ?? 0.0).toDouble(),
      distanceIn: json['distance_in'] ?? '',
      deliveryTime: json['delivery time'] ?? '',
      isWishlist: json['is_wishlist'] ?? 0,
      avgRating: (json['avg_rating'] ?? 0.0).toDouble(),
      totalCount: json['total_count']?.toString() ?? '0',
      productCategory: json['productCategory'] ?? [],
      shopStatus: json['shop_status'] ?? false,
      productCount: json['prd_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_name': shopName,
      'logo': logo,
      'banner_image': bannerImage,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'distance_in': distanceIn,
      'delivery time': deliveryTime,
      'is_wishlist': isWishlist,
      'avg_rating': avgRating,
      'total_count': totalCount,
      'productCategory': productCategory,
      'shop_status': shopStatus,
      'prd_count': productCount,
    };
  }

  ShopListModel copyWith({
    int? id,
    String? shopName,
    String? logo,
    String? bannerImage,
    String? latitude,
    String? longitude,
    double? distance,
    String? distanceIn,
    String? deliveryTime,
    int? isWishlist,
    double? avgRating,
    String? totalCount,
    List<dynamic>? productCategory,
    bool? shopStatus,
    int? productCount,
  }) {
    return ShopListModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      logo: logo ?? this.logo,
      bannerImage: bannerImage ?? this.bannerImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      distanceIn: distanceIn ?? this.distanceIn,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      isWishlist: isWishlist ?? this.isWishlist,
      avgRating: avgRating ?? this.avgRating,
      totalCount: totalCount ?? this.totalCount,
      productCategory: productCategory ?? this.productCategory,
      shopStatus: shopStatus ?? this.shopStatus,
      productCount: productCount ?? this.productCount,
    );
  }
}
