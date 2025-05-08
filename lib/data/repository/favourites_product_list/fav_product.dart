import 'package:customer/core/error/failures.dart';
import 'package:customer/data/source/favourites_product_list/fav_product_api_service.dart';
import 'package:customer/domain/favourites_product_list/entities/fav_product_list_response_entity.dart';
import 'package:customer/domain/favourites_product_list/repository/fav_product_list.dart';
import 'package:dartz/dartz.dart';

class FavProductRepositoryImpl implements FavProductRepository {
  final FavProductApiService _favProductApiService;

  FavProductRepositoryImpl({
    required FavProductApiService favProductApiService,
  }) : _favProductApiService = favProductApiService;

  @override
  Future<Either<Failure, FavProductListResponseEntity>> getFavProductList() {
    return _favProductApiService.getFavProductList();
  }
}
