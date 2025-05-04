import 'package:customer/core/error/failures.dart';
import 'package:customer/data/source/profile/profile_api_service.dart';
import 'package:customer/domain/profile/entities/customer_details_entity.dart';
import 'package:customer/domain/profile/entities/customer_details_params.dart';
import 'package:customer/domain/profile/entities/customer_details_update_responce.dart';
import 'package:customer/domain/profile/repository/profile.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _profileApiService;
  ProfileRepositoryImpl({required ProfileApiService profileApiService})
      : _profileApiService = profileApiService;

  @override
  Future<Either<Failure, CustomerDetailsUpdateResponseEntity>>
      updateCustomerDetails(CustomerDetailsParams params) async {
    return await _profileApiService.updateCustomerDetails(params);
  }

  @override
  Future<Either<Failure, CustomerDetailsResponseEntity>>
      getCustomerDetails() async {
    return await _profileApiService.getCustomerDetails();
  }
}
