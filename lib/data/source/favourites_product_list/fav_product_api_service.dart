import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/favourites_product_list/fav_product_list_response_model.dart';
import 'package:customer/domain/favourites_product_list/entities/fav_product_list_response_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavProductApiService {
  Future<Either<Failure, FavProductListResponseEntity>> getFavProductList();
}

class FavProductApiServiceImpl implements FavProductApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;

  FavProductApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, FavProductListResponseEntity>>
      getFavProductList() async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/product/prd_wishlist',
      );
      if (response.statusCode == 200) {
        return Right(FavProductListResponseModel.fromJson(response.data));
      }
      return const Left(
          ServerFailure(message: 'Failed to get fav product list'));
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
