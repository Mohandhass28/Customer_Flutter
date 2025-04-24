import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/address_entity.dart';
import '../repository/address.dart';

class GetDefaultAddressUseCase {
  final AddressRepository _addressRepository;

  GetDefaultAddressUseCase({required AddressRepository addressRepository})
      : _addressRepository = addressRepository;

  Future<Either<Failure, AddressEntity>> call() async {
    return await _addressRepository.getDefaultAddress();
  }
}
