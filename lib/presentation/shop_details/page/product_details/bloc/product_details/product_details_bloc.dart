import 'package:bloc/bloc.dart';
import 'package:customer/data/models/product/product_details/index.dart';
import 'package:customer/domain/product/entities/product_details_params.dart';
import 'package:customer/domain/product/usecases/product_details_usecase.dart';
import 'package:equatable/equatable.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductDetailsUsecase _productDetailsUsecase;
  ProductDetailsBloc({required ProductDetailsUsecase productDetailsUsecase})
      : _productDetailsUsecase = productDetailsUsecase,
        super(ProductDetailsState()) {
    on<GetProductDetailsEvent>(_getProductDetails);
    on<UpdateTotalPriceEvent>(_updateTotalPrice);
  }

  Future<void> _getProductDetails(
      GetProductDetailsEvent event, Emitter<ProductDetailsState> emit) async {
    emit(state.copyWith(status: ProductDetailsStatus.loading));
    final result = await _productDetailsUsecase(event.params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProductDetailsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (productDetails) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            productDetails: productDetails as ProductDetailsResponseModel,
          ),
        );
      },
    );
  }

  void _updateTotalPrice(
    UpdateTotalPriceEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    emit(state.copyWith(totalPrice: event.totalPrice));
  }
}
