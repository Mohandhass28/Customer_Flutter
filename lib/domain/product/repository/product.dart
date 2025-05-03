import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/product/entities/product_details/product_details_response_entity.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/entities/wish_list_product_param.dart';
import 'package:customer/domain/product/entities/wish_list_product_responce.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetailsResponseEntity>> getProductDetails(
      ProductDetailsParams params);

  Future<Either<Failure, WishListProductResponse>> addRemoveProductWishlist(
      WishListProductParams params);
}
