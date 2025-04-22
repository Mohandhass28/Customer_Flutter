import 'package:customer/core/error/failures.dart';
import 'package:customer/data/source/address/address_api_service.dart';
import 'package:customer/domain/address/entities/address_entity.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:customer/domain/address/repository/address.dart';
import 'package:dartz/dartz.dart';

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
}
