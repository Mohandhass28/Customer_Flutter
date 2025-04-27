import 'package:equatable/equatable.dart';
import 'product_data_entity.dart';

class ProductDetailsResponseEntity extends Equatable {
  final int status;
  final ProductDataEntity productData;
  final String msg;

  const ProductDetailsResponseEntity({
    required this.status,
    required this.productData,
    required this.msg,
  });

  @override
  List<Object?> get props => [status, productData, msg];
}
