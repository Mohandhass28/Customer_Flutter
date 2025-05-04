import 'package:customer/data/models/shop/shop_list/shop_list_model.dart';
import 'package:customer/data/models/shop/shop_list/shop_category_model.dart';

class ShopListResponseModel {
  final int status;
  final List<ShopListModel> shopList;
  final List<ShopCategoryModel> shopCategoryList;
  final String msg;

  ShopListResponseModel({
    required this.status,
    required this.shopList,
    required this.shopCategoryList,
    required this.msg,
  });

  factory ShopListResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopListResponseModel(
      status: json['status'] ?? 0,
      shopList: (json['shop_list'] as List<dynamic>?)
              ?.map((e) => ShopListModel.fromJson(e))
              .toList() ??
          [],
      shopCategoryList: (json['shop_category_list'] as List<dynamic>?)
              ?.map((e) => ShopCategoryModel.fromJson(e))
              .toList() ??
          [],
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'shop_list': shopList.map((e) => e.toJson()).toList(),
      'shop_category_list': shopCategoryList.map((e) => e.toJson()).toList(),
      'msg': msg,
    };
  }

  copyWith({
    int? status,
    List<ShopListModel>? shopList,
    List<ShopCategoryModel>? shopCategoryList,
    String? msg,
  }) {
    return ShopListResponseModel(
      status: status ?? this.status,
      shopList: shopList ?? this.shopList,
      shopCategoryList: shopCategoryList ?? this.shopCategoryList,
      msg: msg ?? this.msg,
    );
  }
}
