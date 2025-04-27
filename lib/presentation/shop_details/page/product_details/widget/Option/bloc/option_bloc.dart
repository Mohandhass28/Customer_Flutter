import 'package:bloc/bloc.dart';
import 'package:customer/common/models/index.dart';
import 'package:equatable/equatable.dart';

part 'option_event.dart';
part 'option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState> {
  OptionBloc() : super(OptionState()) {
    on<AddOptionEvent>(_addOptiontEvent);
    on<IncreaseOptionEvent>(_increaseOptiontEvent);
    on<DecreaseOptionEvent>(_decreaseOptiontEvent);
  }
  void _addOptiontEvent(AddOptionEvent event, Emitter<OptionState> emit) {
    // Check if variant already exists
    final existingVariant = state.optionList.any(
      (element) => element.id == event.optionAddCartModel.id,
    );

    if (!existingVariant) {
      emit(state.copyWith(
        optionList: [...state.optionList, event.optionAddCartModel],
      ));
    }
  }

  void _increaseOptiontEvent(
      IncreaseOptionEvent event, Emitter<OptionState> emit) {
    final variantItem = state.optionList.firstWhere(
      (element) => element.id == event.optionAddCartModel.id,
      orElse: () => event.optionAddCartModel,
    );
    final newvariantItem = OptionAddCartModel(
      id: variantItem.id,
      quantity: variantItem.quantity + 1,
    );

    final price = double.parse(event.price.toString());

    final updatedList = state.optionList.map((item) {
      if (item.id == event.optionAddCartModel.id) {
        return newvariantItem;
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        totalPrice: state.totalPrice + price,
        optionList: updatedList,
      ),
    );
  }

  void _decreaseOptiontEvent(
      DecreaseOptionEvent event, Emitter<OptionState> emit) {
    final variantItem = state.optionList.firstWhere(
      (element) => element.id == event.optionAddCartModel.id,
      orElse: () => event.optionAddCartModel,
    );
    if (variantItem.quantity == 0) {
      return;
    }
    final newvariantItem = OptionAddCartModel(
      id: variantItem.id,
      quantity: variantItem.quantity - 1,
    );

    final price = double.parse(event.price.toString());

    final updatedList = state.optionList.map((item) {
      if (item.id == event.optionAddCartModel.id) {
        return newvariantItem;
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        totalPrice: state.totalPrice - price,
        optionList: updatedList,
      ),
    );
  }
}
