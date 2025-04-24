import 'package:customer/core/error/failures.dart';
import 'package:customer/domain/address/entities/address_entity.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:customer/domain/address/entities/create_address_entity.dart';
import 'package:customer/domain/address/repository/address.dart';
import 'package:dartz/dartz.dart';

class AddressListUseCase {
  final AddressRepository _addressRepository;

  AddressListUseCase({required AddressRepository addressRepository})
      : _addressRepository = addressRepository;

  Future<Either<Failure, List<AddressEntity>>> call(AddressParam params) async {
    return await _addressRepository.getAddress(params);
  }

  Future<Either<Failure, bool>> setDefaultAddress(int addressId) async {
    return await _addressRepository.setDefaultAddress(addressId);
  }

  Future<Either<Failure, bool>> createAddress(
      CreateAddressEntity params) async {
    return await _addressRepository.createAddress(params);
  }
}
