import 'dart:async';

import 'package:customer/core/services/cart_refresh_service.dart';
import 'package:customer/data/models/cart/cart_list/cart_data_model.dart';
import 'package:customer/data/models/cart/cart_list/cart_response_model.dart';
import 'package:customer/domain/cart/usecases/cart_list_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_list_event.dart';
part 'cart_list_state.dart';

class CartListBloc extends Bloc<CartListEvent, CartListState> {
  final CartListUsecase _cartListUsecase;
  late final StreamSubscription _refreshSubscription;

  CartListBloc({required CartListUsecase cartListUsecase})
      : _cartListUsecase = cartListUsecase,
        super(CartListState()) {
    on<GetCartListEvent>(_getCartList);
    on<UpdateCartListEvent>(_updateCartList);

    // Subscribe to refresh events
    _refreshSubscription = sl<CartRefreshService>()
        .refreshStream
        .listen((_) => add(GetCartListEvent()));
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    return super.close();
  }

  Future<void> _getCartList(
      GetCartListEvent event, Emitter<CartListState> emit) async {
    emit(state.copyWith(status: CartListStatus.loading));
    final result = await _cartListUsecase();
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CartListStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (cartList) {
        emit(
          state.copyWith(
            status: CartListStatus.success,
            cartList: cartList as CartResponseModel,
          ),
        );
      },
    );
  }

  void _updateCartList(
    UpdateCartListEvent event,
    Emitter<CartListState> emit,
  ) {
    emit(state.copyWith(
      status: CartListStatus.loading,
    ));
    emit(state.copyWith(
      cartList: event.cartList,
    ));
    emit(state.copyWith(
      status: CartListStatus.success,
    ));
  }
}
