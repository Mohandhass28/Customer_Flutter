import 'package:bloc/bloc.dart';
import 'package:customer/data/models/shop/shop_details/shop_details_model.dart';
import 'package:customer/domain/shop/entities/shop_details/shop_details_params.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:equatable/equatable.dart';

part 'shop_details_event.dart';
part 'shop_details_state.dart';

class ShopDetailsBloc extends Bloc<ShopDetailsEvent, ShopDetailsState> {
  final ShopDetailsUsecase _shopDetailsUsecase;

  ShopDetailsBloc({required ShopDetailsUsecase shopDetailsUsecase})
      : _shopDetailsUsecase = shopDetailsUsecase,
        super(
          ShopDetailsState(),
        ) {
    on<GetShopDetailsEvent>(_getShopDetails);
  }
  Future<void> _getShopDetails(
      GetShopDetailsEvent event, Emitter<ShopDetailsState> emit) async {
    emit(state.copyWith(status: ShopDetailsStatus.loading));
    final result = await _shopDetailsUsecase(event.params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ShopDetailsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (shopDetails) {
        emit(
          state.copyWith(
            status: ShopDetailsStatus.success,
            shopDetails: shopDetails as ShopDetailsResponseModel,
          ),
        );
      },
    );
  }
}
