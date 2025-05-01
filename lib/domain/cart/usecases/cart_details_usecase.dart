import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/cart/entities/cart_details/cart_response_entity.dart';
import 'package:customer/domain/cart/repository/cart.dart';
import 'package:dartz/dartz.dart';

class CartDetailsUsecase {
  final CartRepository _cartRepository;
  CartDetailsUsecase({required CartRepository cartRepository})
      : _cartRepository = cartRepository;
  Future<Either<Failure, CartDetailsResponseEntity>> call() async {
    return await _cartRepository.getCartDetails();
  }
}
