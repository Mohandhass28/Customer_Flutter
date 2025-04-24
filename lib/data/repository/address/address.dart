import 'package:customer/core/error/failures.dart';
import 'package:customer/data/models/address/create_address_model.dart';
import 'package:customer/data/source/address/address_api_service.dart';
import 'package:customer/domain/address/entities/address_entity.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:customer/domain/address/repository/address.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/address/entities/create_address_entity.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressApiService _addressApiService;
  AddressRepositoryImpl({required AddressApiService addressApiService})
      : _addressApiService = addressApiService;

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddress(AddressParam params) {
    return _addressApiService.getAddress(params);
  }

  @override
  Future<Either<Failure, bool>> setDefaultAddress(int addressId) {
    return _addressApiService.setDefaultAddress(addressId);
  }

  @override
  Future<Either<Failure, bool>> createAddress(CreateAddressEntity params) {
    return _addressApiService.createAddress(CreateAddressModel(
      type: params.type,
      receiverName: params.receiverName,
      receiverContact: params.receiverContact,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      areaSector: params.areaSector,
      isDefault: params.isDefault,
    ));
  }

  @override
  Future<Either<Failure, AddressEntity>> getDefaultAddress() async {
    return await _addressApiService.getdefaultAddress();
  }
}
