part of 'variant_bloc.dart';

class VariantState extends Equatable {
  final List<VariantAddCartModel> variantList;
  final double totalPrice;

  const VariantState({
    this.variantList = const [],
    this.totalPrice = 0.0,
  });

  VariantState copyWith({
    List<VariantAddCartModel>? variantList,
    double? totalPrice,
  }) {
    return VariantState(
      variantList: variantList ?? this.variantList,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [variantList, totalPrice];
}
