import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/profile/entities/customer_details_entity.dart';
import 'package:customer/domain/profile/entities/customer_details_params.dart';
import 'package:customer/domain/profile/entities/customer_details_update_responce.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, CustomerDetailsResponseEntity>> getCustomerDetails();
  Future<Either<Failure, CustomerDetailsUpdateResponseEntity>>
      updateCustomerDetails(CustomerDetailsParams params);
}
