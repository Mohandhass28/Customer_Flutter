part of 'option_bloc.dart';

class OptionState extends Equatable {
  final List<OptionAddCartModel> optionList;
  final double totalPrice;

  const OptionState({
    this.optionList = const [],
    this.totalPrice = 0.0,
  });

  OptionState copyWith({
    List<OptionAddCartModel>? optionList,
    double? totalPrice,
  }) {
    return OptionState(
      optionList: optionList ?? this.optionList,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [optionList, totalPrice];
}
