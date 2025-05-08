import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/favourites_product_list/entities/fav_product_list_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FavProductRepository {
  Future<Either<Failure, FavProductListResponseEntity>> getFavProductList();
}
