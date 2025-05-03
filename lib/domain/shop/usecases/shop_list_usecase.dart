import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_entity.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_params.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_entity.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/entities/wish_list_param.dart';
import 'package:customer/domain/shop/entities/wish_list_responce.dart';
import 'package:customer/domain/shop/repository/shop.dart';
import 'package:dartz/dartz.dart';

class ShopListUsecase {
  final ShopRepository _shopRepository;
  ShopListUsecase({required ShopRepository shopRepository})
      : _shopRepository = shopRepository;

  Future<Either<Failure, List<ShopListEntity>>> call(
      ShopListParams params) async {
    return await _shopRepository.getShopList(params);
  }

  Future<Either<Failure, WishListResponse>> addRemoveShopWishlist(
      WishListParams params) async {
    return await _shopRepository.addRemoveShopWishlist(params);
  }
}

class ShopDetailsUsecase {
  final ShopRepository _shopRepository;
  ShopDetailsUsecase({required ShopRepository shopRepository})
      : _shopRepository = shopRepository;

  Future<Either<Failure, ShopDetailsResponseEntity>> call(
      ShopDetailsParams params) async {
    return await _shopRepository.getShopDetails(params);
  }
}
