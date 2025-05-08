import 'package:customer/domain/favourites_product_list/entities/fav_product_list_response_entity.dart';

import 'fav_product_model.dart';

class FavProductListResponseModel extends FavProductListResponseEntity {
  const FavProductListResponseModel({
    required super.status,
    required super.data,
    required super.msg,
  });

  factory FavProductListResponseModel.fromJson(Map<String, dynamic> json) {
    return FavProductListResponseModel(
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => FavProductModel.fromJson(item))
              .toList() ??
          [],
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => (item as FavProductModel).toJson()).toList(),
      'msg': msg,
    };
  }
}
