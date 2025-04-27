import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/product/product_details/product_details_response_model.dart';
import 'package:customer/domain/product/entities/product_details/product_details_response_entity.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProductApiService {
  Future<Either<Failure, ProductDetailsResponseEntity>> getProductDetails(
      ProductDetailsParams params);
}

class ProductApiServiceImpl implements ProductApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;

  ProductApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, ProductDetailsResponseEntity>> getProductDetails(
      ProductDetailsParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/product/product_details',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(ProductDetailsResponseModel.fromJson(response.data));
      }
      return Left(ServerFailure(
          message:
              'Failed to get product details ${response.data['msg'].toString()}'));
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
