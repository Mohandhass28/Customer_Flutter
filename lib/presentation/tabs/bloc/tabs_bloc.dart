import 'package:bloc/bloc.dart';
import 'package:customer/core/refresh_services/address/address_refresh_service.dart';
import 'package:customer/domain/address/entities/create_address_entity.dart';
import 'package:customer/domain/address/usecases/get_adderss_list_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'tabs_event.dart';
part 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  final AddressListUseCase _addressusace;
  // Flag to prevent duplicate address creation
  bool _isProcessingAddressCreation = false;

  TabsBloc({required AddressListUseCase addressusace})
      : _addressusace = addressusace,
        super(TabsState()) {
    on<setDefaultAddressEvent>(_setDefaultAddress);
  }

  Future<void> _setDefaultAddress(
      setDefaultAddressEvent event, Emitter<TabsState> emit) async {
    debugPrint("TabsBloc: _setDefaultAddress method called");

    // Check if we're already processing an address creation
    if (_isProcessingAddressCreation) {
      debugPrint(
          "TabsBloc: Already processing an address creation, ignoring duplicate event");
      return;
    }

    // Set the flag to prevent duplicate processing
    _isProcessingAddressCreation = true;

    try {
      emit(state.copyWith(status: TabsStatus.loading));
      debugPrint("TabsBloc: State updated to loading");

      debugPrint(
          "TabsBloc: Calling createAddress with params: ${event.params.address}");
      final result = await _addressusace.createAddress(event.params);

      result.fold(
        (failure) {
          debugPrint(
              "TabsBloc: Create address failed with error: ${failure.message}");
          emit(state.copyWith(
            status: TabsStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (address) {
          debugPrint("TabsBloc: Create address succeeded");
          emit(
            state.copyWith(
              status: TabsStatus.success,
            ),
          );
          debugPrint("TabsBloc: Calling refreshAddress");
          sl<AddressRefreshService>().refreshAddress();
        },
      );
    } finally {
      // Reset the flag after a delay to allow the operation to complete
      Future.delayed(Duration(seconds: 5), () {
        _isProcessingAddressCreation = false;
        debugPrint("TabsBloc: Reset address creation flag");
      });
    }
  }
}
