import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/shop/shop_details/shop_details_model.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_entity.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_params.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/entities/wish_list_param.dart';
import 'package:customer/domain/shop/entities/wish_list_responce.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/dio_client.dart';
import '../../models/shop/shop_list/shop_list_model.dart';

abstract class ShopApiService {
  Future<Either<Failure, List<ShopListModel>>> getShopList(
      ShopListParams params);

  Future<Either<Failure, ShopDetailsResponseEntity>> getShopDetails(
      ShopDetailsParams params);

  Future<Either<Failure, WishListResponse>> addRemoveShopWishlist(
      WishListParams params);
}

class ShopApiServiceImpl implements ShopApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;
  ShopApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, List<ShopListModel>>> getShopList(
      ShopListParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/shop_list',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        final shopList = (response.data['shop_list'] as List<dynamic>)
            .map((json) => ShopListModel.fromJson(json))
            .toList();
        return Right(shopList);
      }
      return const Left(ServerFailure(message: 'Failed to get shop list'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, ShopDetailsResponseEntity>> getShopDetails(
      ShopDetailsParams params) async {
    try {
      debugPrint('Fetching shop details with params: ${params.toJson()}');

      final response = await _dioClient.post(
        endpoint: 'customer/shop_details',
        params: params.toJson(),
      );

      debugPrint('Shop details response status: ${response.statusCode}');
      debugPrint('Shop details response data: ${response.data}');

      if (response.statusCode == 200) {
        try {
          final result = ShopDetailsResponseModel.fromJson(response.data);
          debugPrint(
              'Successfully parsed shop details. Product count: ${result.shopData.productList.length}');
          return Right(result);
        } catch (parseError) {
          debugPrint('Error parsing shop details: $parseError');
          return Left(ServerFailure(
              message: 'Error parsing shop details: $parseError'));
        }
      }

      final errorMsg = response.data['msg']?.toString() ?? 'Unknown error';
      debugPrint('Failed to get shop details: $errorMsg');
      return Left(
          ServerFailure(message: 'Failed to get shop details: $errorMsg'));
    } on DioException catch (e) {
      debugPrint('DioException in getShopDetails: ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Left(NetworkFailure(message: 'Network connection failed'));
      }
      return Left(ServerFailure(message: 'Server error: ${e.message}'));
    } catch (e) {
      debugPrint('Unexpected error in getShopDetails: $e');
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, WishListResponse>> addRemoveShopWishlist(
      WishListParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/add_remove_shop_wishlist',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(WishListResponse.fromJson(response.data));
      }
      return const Left(ServerFailure(message: 'Failed to add to wishlist'));
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
}
