import 'package:equatable/equatable.dart';

class OptionAddCartModel extends Equatable {
  final int id;
  final int quantity;

  const OptionAddCartModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }

  OptionAddCartModel copyWith({int? id, int? quantity}) {
    return OptionAddCartModel(
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
