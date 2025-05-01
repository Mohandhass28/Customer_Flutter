import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_responce.dart';
import 'package:customer/domain/cart/repository/cart.dart';
import 'package:dartz/dartz.dart';

class AddToCartUsecase {
  final CartRepository _cartRepository;
  AddToCartUsecase({required CartRepository cartRepository})
      : _cartRepository = cartRepository;
  Future<Either<Failure, AddToCartSuccessResponseModel>> call(
      AddToCartParams params) async {
    return await _cartRepository.addToCart(params);
  }
}
