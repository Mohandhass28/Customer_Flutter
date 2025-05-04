import 'package:customer/core/error/failures.dart';
import 'package:customer/core/network/dio_client.dart';
import 'package:customer/data/models/profile/customer_details_model.dart';
import 'package:customer/domain/profile/entities/customer_details_entity.dart';
import 'package:customer/domain/profile/entities/customer_details_params.dart';
import 'package:customer/domain/profile/entities/customer_details_update_responce.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileApiService {
  Future<Either<Failure, CustomerDetailsResponseEntity>> getCustomerDetails();
  Future<Either<Failure, CustomerDetailsUpdateResponseEntity>>
      updateCustomerDetails(CustomerDetailsParams params);
}

class ProfileApiServiceImpl implements ProfileApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;
  ProfileApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, CustomerDetailsResponseEntity>>
      getCustomerDetails() async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/getProfile',
      );
      if (response.statusCode == 200) {
        return Right(CustomerDetailsResponseModel.fromJson(response.data));
      }
      return const Left(
          ServerFailure(message: 'Failed to get customer details'));
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
  Future<Either<Failure, CustomerDetailsUpdateResponseEntity>>
      updateCustomerDetails(CustomerDetailsParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/auth/updateProfile',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(
            CustomerDetailsUpdateResponseEntity.fromJson(response.data));
      }
      return const Left(
          ServerFailure(message: 'Failed to update customer details'));
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
