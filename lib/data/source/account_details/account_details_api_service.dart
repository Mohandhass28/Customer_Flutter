import 'package:customer/core/error/failures.dart';

import 'package:customer/core/network/dio_client.dart';
import 'package:customer/domain/account_details/entities/account_details_params.dart';
import 'package:customer/domain/account_details/entities/account_details_responce.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountDetailsApiService {
  Future<Either<Failure, AccountDetailsResponse>> addAccountDetails(
      AccountDetailsParams params);
}

class AccountDetailsApiServiceImpl implements AccountDetailsApiService {
  final DioClient _dioClient;
  final SharedPreferences _sharedPreferences;
  AccountDetailsApiServiceImpl({
    required DioClient dioClient,
    required SharedPreferences sharedPreferences,
  })  : _dioClient = dioClient,
        _sharedPreferences = sharedPreferences;
  @override
  Future<Either<Failure, AccountDetailsResponse>> addAccountDetails(
      AccountDetailsParams params) async {
    try {
      final response = await _dioClient.post(
        endpoint: 'customer/auth/add_bank_details',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(AccountDetailsResponse.fromJson(response.data));
      }
      return const Left(
          ServerFailure(message: 'Failed to add account details'));
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
