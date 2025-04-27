import 'package:equatable/equatable.dart';

class ShopDetailsResponseEntity extends Equatable {
  final int status;
  final ShopDataEntity shopData;
  final String msg;
  const ShopDetailsResponseEntity({
    required this.status,
    required this.shopData,
    required this.msg,
  });
  @override
  List<Object?> get props => [status, shopData, msg];
}

class ShopDataEntity extends Equatable {
  final ShopDetailsInfoEntity shopDetails;
  final UserDetailsEntity userDetails;
  final List<dynamic> productCategory;
  final double distance;
  final int deliveryTime;
  final int avgRating;
  final String totalCount;
  final List<dynamic> totalReview;
  final List<ProductEntity> productList;
  const ShopDataEntity({
    required this.shopDetails,
    required this.userDetails,
    required this.productCategory,
    required this.distance,
    required this.deliveryTime,
    required this.avgRating,
    required this.totalCount,
    required this.totalReview,
    required this.productList,
  });
  @override
  List<Object?> get props => [
        shopDetails,
        userDetails,
        productCategory,
        distance,
        deliveryTime,
        avgRating,
        totalCount,
        totalReview,
        productList,
      ];
}

class ShopDetailsInfoEntity extends Equatable {
  final int id;
  final String shopName;
  final String? logo;
  final String? bannerImage;
  final String address;
  final String latitude;
  final String longitude;
  final bool status;
  const ShopDetailsInfoEntity({
    required this.id,
    required this.shopName,
    this.logo,
    this.bannerImage,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
  });
  @override
  List<Object?> get props => [
        id,
        shopName,
        logo,
        bannerImage,
        address,
        latitude,
        longitude,
        status,
      ];
}

class UserDetailsEntity extends Equatable {
  final int id;
  final String? name;
  final String? email;
  final String phone;
  final String? dob;
  final String? image;
  const UserDetailsEntity({
    required this.id,
    this.name,
    this.email,
    required this.phone,
    this.dob,
    this.image,
  });
  @override
  List<Object?> get props => [id, name, email, phone, dob, image];
}

class ProductEntity extends Equatable {
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
  const ProductEntity({
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
