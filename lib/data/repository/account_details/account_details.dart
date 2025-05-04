import 'package:customer/core/error/failures.dart';
import 'package:customer/data/source/account_details/account_details_api_service.dart';
import 'package:customer/domain/account_details/entities/account_details_params.dart';
import 'package:customer/domain/account_details/entities/account_details_responce.dart';
import 'package:customer/domain/account_details/repository/account_details.dart';
import 'package:dartz/dartz.dart';

class AccountDetailsRepositoryImpl implements AccountDetailsRepository {
  final AccountDetailsApiService _accountDetailsApiService;

  AccountDetailsRepositoryImpl(
      {required AccountDetailsApiService accountDetailsApiService})
      : _accountDetailsApiService = accountDetailsApiService;

  @override
  Future<Either<Failure, AccountDetailsResponse>> addAccountDetails(
      AccountDetailsParams params) async {
    return await _accountDetailsApiService.addAccountDetails(params);
  }
}
