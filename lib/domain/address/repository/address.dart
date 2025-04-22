import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/address/entities/address_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/address_param.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddress(AddressParam params);
  Future<Either<Failure, bool>> setDefaultAddress(int addressId);
}
