import 'package:bloc/bloc.dart';
import 'package:customer/domain/address/entities/address_param.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/models/address/address_model.dart';

part 'address_book_event.dart';
part 'address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressList> {
  final GetAddressListUseCase _addressusace;
  AddressBookBloc({required GetAddressListUseCase addressusace})
      : _addressusace = addressusace,
        super(AddressList()) {
    on<GetAddressListEvent>(_getAddressList);
    on<SetDefaultAddressEvent>(_setDefaultAddress);
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
      (address) {
        emit(
          state.copyWith(
            status: AddressBookStatus.success,
            addressList: address as List<AddressModel>,
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
}
