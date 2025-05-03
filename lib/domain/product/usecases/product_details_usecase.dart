import 'package:customer/core/error/failures.dart';

import 'package:customer/domain/product/entities/product_details/product_details_response_entity.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/entities/wish_list_product_param.dart';
import 'package:customer/domain/product/entities/wish_list_product_responce.dart';
import 'package:customer/domain/product/repository/product.dart';
import 'package:dartz/dartz.dart';

class ProductDetailsUsecase {
  final ProductRepository _productRepository;
  ProductDetailsUsecase({required ProductRepository productRepository})
      : _productRepository = productRepository;
  Future<Either<Failure, ProductDetailsResponseEntity>> call(
      ProductDetailsParams params) async {
    return await _productRepository.getProductDetails(params);
  }

  Future<Either<Failure, WishListProductResponse>> addRemoveProductWishlist(
      WishListProductParams params) async {
    return await _productRepository.addRemoveProductWishlist(params);
  }
}
