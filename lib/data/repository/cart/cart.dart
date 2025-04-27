import 'package:customer/core/error/failures.dart';
import 'package:customer/data/source/cart/cart_api_service.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_response_entity.dart';
import 'package:customer/domain/cart/repository/cart.dart';
import 'package:dartz/dartz.dart';

class CartRepositoryImpl implements CartRepository {
  final CartApiService _cartApiService;
  CartRepositoryImpl({required CartApiService cartApiService})
      : _cartApiService = cartApiService;
  @override
  Future<Either<Failure, CartResponseEntity>> getCartList() async {
    return await _cartApiService.getCartList();
  }
}
