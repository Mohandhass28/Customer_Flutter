part of 'variant_bloc.dart';

sealed class VariantEvent extends Equatable {
  const VariantEvent();

  @override
  List<Object> get props => [];
}

class AddVariantEvent extends VariantEvent {
  final VariantAddCartModel variantAddCartModel;
  const AddVariantEvent({required this.variantAddCartModel});

  @override
  List<Object> get props => [
        variantAddCartModel,
      ];
}

class IncreaseVariantEvent extends VariantEvent {
  final VariantAddCartModel variantAddCartModel;
  final int price;
  const IncreaseVariantEvent({
    required this.variantAddCartModel,
    required this.price,
  });

  @override
  List<Object> get props => [
        variantAddCartModel,
        price,
      ];
}

class DecreaseVariantEvent extends VariantEvent {
  final VariantAddCartModel variantAddCartModel;
  final int price;
  const DecreaseVariantEvent(
      {required this.variantAddCartModel, required this.price});

  @override
  List<Object> get props => [
        variantAddCartModel,
        price,
      ];
}
