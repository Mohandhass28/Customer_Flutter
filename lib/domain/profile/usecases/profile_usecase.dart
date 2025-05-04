import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/profile/entities/customer_details_entity.dart';
import 'package:customer/domain/profile/entities/customer_details_params.dart';
import 'package:customer/domain/profile/entities/customer_details_update_responce.dart';
import 'package:customer/domain/profile/repository/profile.dart';
import 'package:dartz/dartz.dart';

class ProfileUseCase {
  final ProfileRepository _profileRepository;
  ProfileUseCase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;
  Future<Either<Failure, CustomerDetailsResponseEntity>>
      getCustomerDetails() async {
    return await _profileRepository.getCustomerDetails();
  }

  Future<Either<Failure, CustomerDetailsUpdateResponseEntity>>
      updateCustomerDetails(CustomerDetailsParams params) async {
    return await _profileRepository.updateCustomerDetails(params);
  }
}
