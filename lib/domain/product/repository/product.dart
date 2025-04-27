import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/product/entities/product_details/product_details_response_entity.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetailsResponseEntity>> getProductDetails(
      ProductDetailsParams params);
}
