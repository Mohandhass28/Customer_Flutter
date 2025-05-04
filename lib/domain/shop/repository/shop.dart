import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/shop/shop_list/shop_list_response_model.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_entity.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_params.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_entity.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/entities/wish_list_param.dart';
import 'package:customer/domain/shop/entities/wish_list_responce.dart';
import 'package:dartz/dartz.dart';

abstract class ShopRepository {
  Future<Either<Failure, ShopListResponseModel>> getShopList(
      ShopListParams params);

  Future<Either<Failure, ShopDetailsResponseEntity>> getShopDetails(
      ShopDetailsParams params);
  Future<Either<Failure, WishListResponse>> addRemoveShopWishlist(
      WishListParams params);
}
