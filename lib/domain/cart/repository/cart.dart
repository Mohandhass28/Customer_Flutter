import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CartRepository {
  Future<Either<Failure, CartResponseEntity>> getCartList();
}
