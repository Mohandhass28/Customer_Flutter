import 'package:bloc/bloc.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:customer/domain/address/entities/create_address_entity.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/address/address_model.dart';

part 'address_book_event.dart';
part 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressList> {
  final AddressListUseCase _addressusace;
  AddressBookBloc({required AddressListUseCase addressusace})
      : _addressusace = addressusace,
        super(AddressList()) {
    on<GetAddressListEvent>(_getAddressList);
    on<SetDefaultAddressEvent>(_setDefaultAddress);
    on<CreateAddressEvent>(_createAddress);
  }

  Future<void> _getAddressList(
      GetAddressListEvent event, Emitter<AddressList> emit) async {
    emit(state.copyWith(status: AddressBookStatus.loading));
    final result = await _addressusace(event.addressParam);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AddressBookStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (addressEntities) {
        // Convert List<AddressEntity> to List<AddressModel>
        final addressModels = addressEntities
            .map((entity) => entity is AddressModel
                ? entity
                : AddressModel(
                    id: entity.id,
                    type: entity.type,
                    receiverName: entity.receiverName,
                    receiverContact: entity.receiverContact,
                    address: entity.address,
                    areaSector: entity.areaSector,
                    latitude: entity.latitude,
                    longitude: entity.longitude,
                    isDefault: entity.isDefault,
                    status: entity.status,
                  ))
            .toList();

        emit(
          state.copyWith(
            status: AddressBookStatus.success,
            addressList: addressModels,
          ),
        );
      },
    );
  }

  Future<void> _setDefaultAddress(
      SetDefaultAddressEvent event, Emitter<AddressList> emit) async {
    emit(state.copyWith(status: AddressBookStatus.loading));
    final result = await _addressusace.setDefaultAddress(event.addressId);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AddressBookStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (address) {
        emit(
          state.copyWith(
            status: AddressBookStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _createAddress(
      CreateAddressEvent event, Emitter<AddressList> emit) async {
    emit(state.copyWith(status: AddressBookStatus.loading));
    final result = await _addressusace.createAddress(event.createAddressEntity);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AddressBookStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (address) {
        emit(
          state.copyWith(
            status: AddressBookStatus.success,
          ),
        );
      },
    );
  }
}
