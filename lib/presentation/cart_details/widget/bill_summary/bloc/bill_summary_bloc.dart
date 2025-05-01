import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customer/core/services/bill_summary_refresh_service.dart';
import 'package:customer/core/services/cart_refresh_service.dart';
import 'package:customer/data/models/cart/cart_details/cart_response_model.dart';
import 'package:customer/domain/cart/usecases/cart_details_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'bill_summary_event.dart';
part 'bill_summary_state.dart';

class BillSummaryBloc extends Bloc<BillSummaryEvent, BillSummaryState> {
  late final StreamSubscription _refreshSubscription;
  final CartDetailsUsecase _cartDetailsUsecase;

  BillSummaryBloc({
    required CartDetailsUsecase cartDetailsUsecase,
  })  : _cartDetailsUsecase = cartDetailsUsecase,
        super(BillSummaryState()) {
    on<GetBillSummaryEvent>(_getCartDetails);

    _refreshSubscription = sl<BillSummaryRefreshService>()
        .refreshStream
        .listen((_) => add(GetBillSummaryEvent()));
  }

  void _getCartDetails(
    BillSummaryEvent event,
    Emitter<BillSummaryState> emit,
  ) async {
    emit(state.copyWith(status: BillSummaryStatus.loading));
    final result = await _cartDetailsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: BillSummaryStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (cartDetails) {
        emit(
          state.copyWith(
            status: BillSummaryStatus.success,
            cartDetails: cartDetails as CartDetailsResponseModel,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _refreshSubscription.cancel();
    return super.close();
  }
}
