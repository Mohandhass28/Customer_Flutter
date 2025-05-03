import 'package:bloc/bloc.dart';
import 'package:customer/core/refresh_services/address/address_refresh_service.dart';
import 'package:customer/domain/address/entities/create_address_entity.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'tabs_event.dart';
part 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  final AddressListUseCase _addressusace;
  TabsBloc({required AddressListUseCase addressusace})
      : _addressusace = addressusace,
        super(TabsState()) {
    on<setDefaultAddressEvent>(_setDefaultAddress);
  }
  Future<void> _setDefaultAddress(
      setDefaultAddressEvent event, Emitter<TabsState> emit) async {
    emit(state.copyWith(status: TabsStatus.loading));
    final result = await _addressusace.createAddress(event.params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TabsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (address) {
        emit(
          state.copyWith(
            status: TabsStatus.success,
          ),
        );
        sl<AddressRefreshService>().refreshAddress();
      },
    );
  }
}
