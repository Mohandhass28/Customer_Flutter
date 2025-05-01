import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_responce.dart';
import 'package:customer/domain/cart/entities/cart_details/cart_response_entity.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CartRepository {
  Future<Either<Failure, CartResponseEntity>> getCartList();
  Future<Either<Failure, CartDetailsResponseEntity>> getCartDetails();
  Future<Either<Failure, AddToCartSuccessResponseModel>> addToCart(
      AddToCartParams params);

  Future<Either<Failure, AddToCartSuccessResponseModel>> modifyCart(
      AddToCartParams params);
}
