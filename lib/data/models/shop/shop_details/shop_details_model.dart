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
    // Handle totalCount properly - ensure it's always a string
    String totalCount;
    if (json['total_count'] == null) {
      totalCount = '0';
    } else if (json['total_count'] is int) {
      totalCount = json['total_count'].toString();
    } else {
      totalCount = json['total_count'].toString();
    }

    // Handle distance properly - ensure it's always a double
    double distance;
    if (json['distance'] == null) {
      distance = 0.0;
    } else if (json['distance'] is int) {
      distance = (json['distance'] as int).toDouble();
    } else if (json['distance'] is String) {
      distance = double.tryParse(json['distance'] as String) ?? 0.0;
    } else {
      distance = (json['distance'] ?? 0.0).toDouble();
    }

    // Handle deliveryTime properly - ensure it's always an int
    int deliveryTime;
    if (json['delivery_time'] == null) {
      deliveryTime = 0;
    } else if (json['delivery_time'] is String) {
      deliveryTime = int.tryParse(json['delivery_time'] as String) ?? 0;
    } else {
      deliveryTime = json['delivery_time'] ?? 0;
    }

    // Handle avgRating properly - ensure it's always an int
    int avgRating;
    if (json['avg_rating'] == null) {
      avgRating = 0;
    } else if (json['avg_rating'] is String) {
      avgRating = int.tryParse(json['avg_rating'] as String) ?? 0;
    } else {
      avgRating = json['avg_rating'] ?? 0;
    }

    // Handle productList properly
    List<ProductModel> productList = [];
    if (json['productList'] != null && json['productList'] is List) {
      productList = (json['productList'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    return ShopDataModel(
      shopDetails: ShopDetailsInfoModel.fromJson(json['shop_details'] ?? {}),
      userDetails: UserDetailsModel.fromJson(json['user_details'] ?? {}),
      productCategory: json['product_category'] ?? [],
      distance: distance,
      deliveryTime: deliveryTime,
      avgRating: avgRating,
      totalCount: totalCount,
      totalReview: json['total_review'] ?? [],
      productList: productList,
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
    required super.isOpen,
  });

  factory ShopDetailsInfoModel.fromJson(Map<String, dynamic> json) {
    // Handle id properly - ensure it's always an int
    int id;
    if (json['id'] == null) {
      id = 0;
    } else if (json['id'] is String) {
      id = int.tryParse(json['id'] as String) ?? 0;
    } else {
      id = json['id'] ?? 0;
    }

    // Handle latitude and longitude properly - ensure they're always strings
    String latitude = (json['latitude'] ?? '').toString();
    String longitude = (json['longitude'] ?? '').toString();

    // Handle status and isOpen properly - ensure they're always booleans
    bool status;
    if (json['status'] == null) {
      status = false;
    } else if (json['status'] is int) {
      status = (json['status'] as int) != 0;
    } else if (json['status'] is String) {
      status = (json['status'] as String).toLowerCase() == 'true';
    } else {
      status = json['status'] ?? false;
    }

    bool isOpen;
    if (json['is_open'] == null) {
      isOpen = false;
    } else if (json['is_open'] is int) {
      isOpen = (json['is_open'] as int) != 0;
    } else if (json['is_open'] is String) {
      isOpen = (json['is_open'] as String).toLowerCase() == 'true';
    } else {
      isOpen = json['is_open'] ?? false;
    }

    return ShopDetailsInfoModel(
      id: id,
      shopName: json['shop_name'] ?? '',
      logo: json['logo'],
      bannerImage: json['banner_image'],
      address: json['address'] ?? '',
      latitude: latitude,
      longitude: longitude,
      status: status,
      isOpen: isOpen,
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
    // Handle id properly - ensure it's always an int
    int id;
    if (json['id'] == null) {
      id = 0;
    } else if (json['id'] is String) {
      id = int.tryParse(json['id'] as String) ?? 0;
    } else {
      id = json['id'] ?? 0;
    }

    // Handle phone properly - ensure it's always a string
    String phone = (json['phone'] ?? '').toString();

    return UserDetailsModel(
      id: id,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: phone,
      dob: json['dob']?.toString(),
      image: json['image']?.toString(),
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
    // Handle id properly - ensure it's always an int
    int id;
    if (json['id'] == null) {
      id = 0;
    } else if (json['id'] is String) {
      id = int.tryParse(json['id'] as String) ?? 0;
    } else {
      id = json['id'] ?? 0;
    }

    // Handle isDiscountedPrd properly - ensure it's always an int
    int isDiscountedPrd;
    if (json['is_discounted_prd'] == null) {
      isDiscountedPrd = 0;
    } else if (json['is_discounted_prd'] is String) {
      isDiscountedPrd = int.tryParse(json['is_discounted_prd'] as String) ?? 0;
    } else if (json['is_discounted_prd'] is bool) {
      isDiscountedPrd = (json['is_discounted_prd'] as bool) ? 1 : 0;
    } else {
      isDiscountedPrd = json['is_discounted_prd'] ?? 0;
    }

    // Handle prdAvgRating properly - ensure it's always an int
    int prdAvgRating;
    if (json['prd_avg_rating'] == null) {
      prdAvgRating = 0;
    } else if (json['prd_avg_rating'] is String) {
      prdAvgRating = int.tryParse(json['prd_avg_rating'] as String) ?? 0;
    } else {
      prdAvgRating = json['prd_avg_rating'] ?? 0;
    }

    // Handle string fields properly
    String price = (json['price'] ?? '0.00').toString();
    String slashPrice = (json['slash_price'] ?? '0.00').toString();
    String prdTotalCount = (json['prd_total_count'] ?? '0').toString();

    return ProductModel(
      id: id,
      name: json['name']?.toString() ?? '',
      prdTagName: json['prd_tag_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: price,
      isDiscountedPrd: isDiscountedPrd,
      slashPrice: slashPrice,
      image: json['image']?.toString() ?? '',
      prdAvgRating: prdAvgRating,
      prdTotalCount: prdTotalCount,
      prdFoodType: json['prd_food_type']?.toString() ?? '',
    );
  }
}
