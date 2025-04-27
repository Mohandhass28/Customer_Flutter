import 'package:bloc/bloc.dart';
import 'package:customer/data/models/shop/shop_list/shop_list_model.dart';
import 'package:customer/domain/shop/entities/shop_list/shop_list_params.dart';
import 'package:customer/domain/shop/usecases/shop_list_usecase.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ShopListUsecase _shopListUsecase;
  HomeBloc({required ShopListUsecase shopListUsecase})
      : _shopListUsecase = shopListUsecase,
        super(HomeState()) {
    on<GetShopListEvent>(_getShopList);
  }
  Future<void> _getShopList(
      GetShopListEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _shopListUsecase(event.params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (shopList) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            shopList: shopList as List<ShopListModel>,
          ),
        );
      },
    );
  }
}
