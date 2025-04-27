part of 'option_bloc.dart';

sealed class OptionEvent extends Equatable {
  const OptionEvent();

  @override
  List<Object> get props => [];
}

class AddOptionEvent extends OptionEvent {
  final OptionAddCartModel optionAddCartModel;
  const AddOptionEvent({
    required this.optionAddCartModel,
  });

  @override
  List<Object> get props => [
        optionAddCartModel,
      ];
}

class IncreaseOptionEvent extends OptionEvent {
  final OptionAddCartModel optionAddCartModel;
  final int price;
  const IncreaseOptionEvent({
    required this.optionAddCartModel,
    required this.price,
  });

  @override
  List<Object> get props => [
        optionAddCartModel,
        price,
      ];
}

class DecreaseOptionEvent extends OptionEvent {
  final OptionAddCartModel optionAddCartModel;
  final int price;
  const DecreaseOptionEvent({
    required this.optionAddCartModel,
    required this.price,
  });

  @override
  List<Object> get props => [
        optionAddCartModel,
        price,
      ];
}
