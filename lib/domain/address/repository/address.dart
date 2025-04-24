import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/address/entities/address_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/address_param.dart';
import '../entities/create_address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddress(AddressParam params);
  Future<Either<Failure, bool>> setDefaultAddress(int addressId);
  Future<Either<Failure, bool>> createAddress(CreateAddressEntity params);
  Future<Either<Failure, AddressEntity>> getDefaultAddress();
}
