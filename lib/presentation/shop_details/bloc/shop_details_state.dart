part of 'shop_details_bloc.dart';

sealed class ShopDetailsState extends Equatable {
  const ShopDetailsState();
  
  @override
  List<Object> get props => [];
}

final class ShopDetailsInitial extends ShopDetailsState {}
