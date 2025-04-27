import 'package:equatable/equatable.dart';

class VariantAddCartModel extends Equatable {
  final int id;
  final int quantity;

  const VariantAddCartModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }

  VariantAddCartModel copyWith({int? id, int? quantity}) {
    return VariantAddCartModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [
        id,
        quantity,
      ];
}
