import 'package:equatable/equatable.dart';
import 'fav_product_entity.dart';

class FavProductListResponseEntity extends Equatable {
  final int status;
  final List<FavProductEntity> data;
  final String msg;

  const FavProductListResponseEntity({
    required this.status,
    required this.data,
    required this.msg,
  });

  @override
  List<Object?> get props => [status, data, msg];
}