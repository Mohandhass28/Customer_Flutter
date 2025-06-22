import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/cart/cart_details/cart_response_model.dart';
import 'package:customer/data/models/cart/cart_list/cart_response_model.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_responce.dart';
import 'package:customer/domain/cart/entities/cart_details/cart_response_entity.dart';
import 'package:customer/domain/cart/entities/cart_list/cart_response_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartApiService {
  Future<Either<Failure, CartResponseEntity>> getCartList();
  Future<Either<Failure, CartDetailsResponseEntity>> getCartDetails();
  Future<Either<Failure, AddToCartSuccessResponseModel>> addToCart(
      AddToCartParams params);
  Future<Either<Failure, AddToCartSuccessResponseModel>> modifyCart(
      AddToCartParams params);
}

class CartApiServiceImpl implements CartApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;

  CartApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, CartResponseEntity>> getCartList() async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/product/cart_list',
      );
      if (response.statusCode == 200) {
        return Right(CartResponseModel.fromJson(response.data));
      }
      return const Left(ServerFailure(message: 'Failed to get cart list'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }
      print(e);
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartDetailsResponseEntity>> getCartDetails() async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/product/cart_details',
      );
      if (response.statusCode == 200) {
        return Right(CartDetailsResponseModel.fromJson(response.data));
      }
      return const Left(ServerFailure(message: 'Failed to get cart details'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddToCartSuccessResponseModel>> addToCart(
      AddToCartParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/product/add_to_cart',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(AddToCartSuccessResponseModel.fromJson(response.data));
      }
      return const Left(ServerFailure(message: 'Failed to add to cart'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddToCartSuccessResponseModel>> modifyCart(
      AddToCartParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/product/add_to_cart',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(AddToCartSuccessResponseModel.fromJson(response.data));
      }
      return Left(ServerFailure(
          message: 'Failed to add to cart ${response.data['msg']}'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(
            NetworkFailure(message: 'Network connection failed ${e.message}'));
      }
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
