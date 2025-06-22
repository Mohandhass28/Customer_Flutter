import 'package:bloc/bloc.dart';
import 'package:customer/core/refresh_services/bill_summary_refresh_service.dart';
import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/data/models/cart/cart_details/cart_response_model.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_responce.dart';
import 'package:customer/domain/cart/usecases/modify_cart_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'cart_details_event.dart';
part 'cart_details_state.dart';

class CartDetailsBloc extends Bloc<CartDetailsEvent, CartDetailsState> {
  final ModifyCartUsecase _modifyCartUsecase;

  CartDetailsBloc({
    required ModifyCartUsecase modifyCartUsecase,
  })  : _modifyCartUsecase = modifyCartUsecase,
        super(CartDetailsState()) {
    on<ModifyCartEvent>(_modifyCartEvent);
  }

  void _modifyCartEvent(
    ModifyCartEvent event,
    Emitter<CartDetailsState> emit,
  ) async {
    emit(state.copyWith(status: CartDetailsStatus.loading));
    final result = await _modifyCartUsecase(event.params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CartDetailsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (modifyCartResponse) {
        emit(
          state.copyWith(
            status: CartDetailsStatus.success,
            modifyCartResponse: modifyCartResponse,
          ),
        );
        sl<CartRefreshService>().refreshCart();
        sl<BillSummaryRefreshService>().refreshBillSummary();
      },
    );
  }
}
