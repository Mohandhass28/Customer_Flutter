import 'package:bloc/bloc.dart';
import 'package:customer/data/models/address/address_model.dart';
import 'package:customer/domain/address/usecases/get_default_address_usecase.dart';
import 'package:equatable/equatable.dart';

part 'address_header_event.dart';
part 'address_header_state.dart';

class AddressHeaderBloc extends Bloc<AddressHeaderEvent, AddressHeaderState> {
  final GetDefaultAddressUseCase _getDfaultusecase;
  AddressHeaderBloc({required GetDefaultAddressUseCase getDfaultusecase})
      : _getDfaultusecase = getDfaultusecase,
        super(AddressHeaderState()) {
    on<AddressHeaderEvent>(_getDefaultAddress);
  }
  Future<void> _getDefaultAddress(
      AddressHeaderEvent event, Emitter<AddressHeaderState> emit) async {
    emit(state.copyWith(status: AddressHeaderStatus.loading));
    final result = await _getDfaultusecase();
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AddressHeaderStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (address) {
        print('right result: $address');
        emit(
          state.copyWith(
            status: AddressHeaderStatus.success,
            address: address as AddressModel,
          ),
        );
      },
    );
  }
}
