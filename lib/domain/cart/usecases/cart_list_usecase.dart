import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_response_entity.dart';
import 'package:customer/domain/cart/repository/cart.dart';
import 'package:dartz/dartz.dart';

class CartListUsecase {
  final CartRepository _cartRepository;
  CartListUsecase({required CartRepository cartRepository})
      : _cartRepository = cartRepository;
  Future<Either<Failure, CartResponseEntity>> call() async {
    return await _cartRepository.getCartList();
  }
}
