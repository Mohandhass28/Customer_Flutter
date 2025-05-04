import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/account_details/entities/account_details_params.dart';
import 'package:customer/domain/account_details/entities/account_details_responce.dart';
import 'package:customer/domain/account_details/repository/account_details.dart';
import 'package:dartz/dartz.dart';

class AddAccountDetailsUsecase {
  final AccountDetailsRepository _accountDetailsRepository;
  AddAccountDetailsUsecase(
      {required AccountDetailsRepository accountDetailsRepository})
      : _accountDetailsRepository = accountDetailsRepository;
  Future<Either<Failure, AccountDetailsResponse>> call(
      AccountDetailsParams params) async {
    return await _accountDetailsRepository.addAccountDetails(params);
  }
}
