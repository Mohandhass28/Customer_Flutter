import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/favourites_product_list/entities/fav_product_list_response_entity.dart';
import 'package:customer/domain/favourites_product_list/repository/fav_product_list.dart';
import 'package:dartz/dartz.dart';

class GetFavProductListUsecase {
  final FavProductRepository _favProductRepository;
  GetFavProductListUsecase({required FavProductRepository favProductRepository})
      : _favProductRepository = favProductRepository;
  Future<Either<Failure, FavProductListResponseEntity>> call() async {
    return await _favProductRepository.getFavProductList();
  }
}
