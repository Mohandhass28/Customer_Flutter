import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/address/address_model.dart';
import 'package:customer/domain/address/entities/address_entity.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/dio_client.dart';

abstract class AddressApiService {
  Future<Either<Failure, List<AddressEntity>>> getAddress(AddressParam params);
  Future<Either<Failure, bool>> setDefaultAddress(int addressId);
}

class AddressApiServiceImpl implements AddressApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;

  AddressApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddress(
      AddressParam params) async {
    try {
      Response response;
      response = await _dioClient.post(
        endpoint: 'customer/address/customerAddressList',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        final addressList = (response.data['data'] as List<dynamic>)
            .map((json) => AddressModel.fromJson(json))
            .toList();
        return Right(addressList);
      }
      return const Left(ServerFailure(message: 'Failed to get address'));
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
  Future<Either<Failure, bool>> setDefaultAddress(int addressId) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/address/setCustomerDefaultAddress',
        params: {'id': addressId},
      );
      if (response.statusCode == 200) {
        return Right(true);
      }
      return const Left(
          ServerFailure(message: 'Failed to set default address'));
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
