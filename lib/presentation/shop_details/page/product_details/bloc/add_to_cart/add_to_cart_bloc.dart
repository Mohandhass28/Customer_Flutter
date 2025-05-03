import 'package:bloc/bloc.dart';
import 'package:customer/core/refresh_services/cart_refresh_service.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_params.dart';
import 'package:customer/domain/cart/entities/add_to_cart/add_to_cart_responce.dart';
import 'package:customer/domain/cart/usecases/add_to_cart_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'add_to_cart_event.dart';
part 'add_to_cart_state.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  final AddToCartUsecase _addToCartUsecase;

  AddToCartBloc({
    required AddToCartUsecase addToCartUsecase,
  })  : _addToCartUsecase = addToCartUsecase,
        super(AddToCartState()) {
    on<AddItemToCartEvent>(_addItemToCartEvent);
  }
  void _addItemToCartEvent(
      AddItemToCartEvent event, Emitter<AddToCartState> emit) async {
    emit(state.copyWith(status: AddToCartStatus.loading));
    final result = await _addToCartUsecase(event.params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AddToCartStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (addToCartResponse) {
        emit(
          state.copyWith(
            status: AddToCartStatus.success,
            addToCartResponse: addToCartResponse,
          ),
        );
      },
    );
  }
}
