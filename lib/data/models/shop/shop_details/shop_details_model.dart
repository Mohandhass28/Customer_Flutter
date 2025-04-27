import '../../../../domain/shop/entities/shop_details/shop_details_entity.dart';

class ShopDetailsResponseModel extends ShopDetailsResponseEntity {
  const ShopDetailsResponseModel({
    required super.status,
    required super.shopData,
    required super.msg,
  });

  factory ShopDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailsResponseModel(
      status: json['status'] ?? 0,
      shopData: ShopDataModel.fromJson(json['shop_data'] ?? {}),
      msg: json['msg'] ?? '',
    );
  }
}

class ShopDataModel extends ShopDataEntity {
  const ShopDataModel({
    required super.shopDetails,
    required super.userDetails,
    required super.productCategory,
    required super.distance,
    required super.deliveryTime,
    required super.avgRating,
    required super.totalCount,
    required super.totalReview,
    required super.productList,
  });

  factory ShopDataModel.fromJson(Map<String, dynamic> json) {
    return ShopDataModel(
      shopDetails: ShopDetailsInfoModel.fromJson(json['shop_details'] ?? {}),
      userDetails: UserDetailsModel.fromJson(json['user_details'] ?? {}),
      productCategory: json['product_category'] ?? [],
      distance: (json['distance'] ?? 0.0).toDouble(),
      deliveryTime: json['delivery_time'] ?? 0,
      avgRating: json['avg_rating'] ?? 0,
      totalCount: json['total_count']?.toString() ?? '0',
      totalReview: json['total_review'] ?? [],
      productList: (json['productList'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ShopDetailsInfoModel extends ShopDetailsInfoEntity {
  const ShopDetailsInfoModel({
    required super.id,
    required super.shopName,
    super.logo,
    super.bannerImage,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.status,
  });

  factory ShopDetailsInfoModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailsInfoModel(
      id: json['id'] ?? 0,
      shopName: json['shop_name'] ?? '',
      logo: json['logo'],
      bannerImage: json['banner_image'],
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      status: json['status'] ?? false,
    );
  }
}

class UserDetailsModel extends UserDetailsEntity {
  const UserDetailsModel({
    required super.id,
    super.name,
    super.email,
    required super.phone,
    super.dob,
    super.image,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      dob: json['dob'],
      image: json['image'],
    );
  }
}

class ProductModel extends ProductEntity {
  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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
}
