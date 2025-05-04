import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/account_details/entities/account_details_params.dart';
import 'package:customer/domain/account_details/entities/account_details_responce.dart';
import 'package:dartz/dartz.dart';

abstract class AccountDetailsRepository {
  Future<Either<Failure, AccountDetailsResponse>> addAccountDetails(
      AccountDetailsParams params);
}
