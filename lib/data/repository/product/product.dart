import 'package:customer/core/error/failures.dart';
import 'package:customer/data/source/product/product_api_service.dart';
import 'package:customer/domain/product/entities/product_details/product_details_response_entity.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/repository/product.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _productApiService;
  ProductRepositoryImpl({required ProductApiService productApiService})
      : _productApiService = productApiService;

  @override
  Future<Either<Failure, ProductDetailsResponseEntity>> getProductDetails(
      ProductDetailsParams params) async {
    return await _productApiService.getProductDetails(params);
  }
}
