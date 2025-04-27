import 'package:bloc/bloc.dart';
import 'package:customer/common/models/cart/variant_add_cart.dart';
import 'package:equatable/equatable.dart';

part 'variant_event.dart';
part 'variant_state.dart';

class VariantBloc extends Bloc<VariantEvent, VariantState> {
  VariantBloc() : super(VariantState()) {
    on<AddVariantEvent>(_addVariantEvent);
    on<IncreaseVariantEvent>(_increaseVariantEvent);
    on<DecreaseVariantEvent>(_decreaseVariantEvent);
  }

  void _addVariantEvent(AddVariantEvent event, Emitter<VariantState> emit) {
    // Check if variant already exists
    final existingVariant = state.variantList.any(
      (element) => element.id == event.variantAddCartModel.id,
    );

    if (!existingVariant) {
      emit(state.copyWith(
        variantList: [...state.variantList, event.variantAddCartModel],
      ));
    }
  }

  void _increaseVariantEvent(
      IncreaseVariantEvent event, Emitter<VariantState> emit) {
    final variantItem = state.variantList.firstWhere(
      (element) => element.id == event.variantAddCartModel.id,
      orElse: () => event.variantAddCartModel,
    );
    final newvariantItem = VariantAddCartModel(
      id: variantItem.id,
      quantity: variantItem.quantity + 1,
    );

    final price = double.parse(event.price.toString());

    final updatedList = state.variantList.map((item) {
      if (item.id == event.variantAddCartModel.id) {
        return newvariantItem;
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        totalPrice: state.totalPrice + price,
        variantList: updatedList,
      ),
    );
  }

  void _decreaseVariantEvent(
      DecreaseVariantEvent event, Emitter<VariantState> emit) {
    final variantItem = state.variantList.firstWhere(
      (element) => element.id == event.variantAddCartModel.id,
      orElse: () => event.variantAddCartModel,
    );
    if (variantItem.quantity == 0) {
      return;
    }
    final newvariantItem = VariantAddCartModel(
      id: variantItem.id,
      quantity: variantItem.quantity - 1,
    );

    final price = double.parse(event.price.toString());

    final updatedList = state.variantList.map((item) {
      if (item.id == event.variantAddCartModel.id) {
        return newvariantItem;
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        totalPrice: state.totalPrice - price,
        variantList: updatedList,
      ),
    );
  }
}
