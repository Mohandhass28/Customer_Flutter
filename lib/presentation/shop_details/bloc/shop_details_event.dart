part of 'shop_details_bloc.dart';

sealed class ShopDetailsEvent extends Equatable {
  const ShopDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetShopDetailsEvent extends ShopDetailsEvent {
  final ShopDetailsParams params;
  const GetShopDetailsEvent({required this.params});

  @override
  List<Object> get props => [];
}
