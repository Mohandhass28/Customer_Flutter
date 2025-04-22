part of 'orders_details_bloc.dart';

sealed class OrdersDetailsState extends Equatable {
  const OrdersDetailsState();
  
  @override
  List<Object> get props => [];
}

final class OrdersDetailsInitial extends OrdersDetailsState {}
