import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/shop/shop_list/shop_list_model.dart';
import 'package:customer/data/source/shop/shop_api_service.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_entity.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_params.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_entity.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/repository/shop.dart';
import 'package:dartz/dartz.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopApiService _shopApiService;
  ShopRepositoryImpl({required ShopApiService shopApiService})
      : _shopApiService = shopApiService;

  @override
  Future<Either<Failure, List<ShopListModel>>> getShopList(
      ShopListParams params) async {
    return await _shopApiService.getShopList(params);
  }

  @override
  Future<Either<Failure, ShopDetailsResponseEntity>> getShopDetails(
      ShopDetailsParams params) async {
    return await _shopApiService.getShopDetails(params);
  }
}
