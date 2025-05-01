part of 'active_order_bloc.dart';

sealed class ActiveOrderState extends Equatable {
  const ActiveOrderState();
  
  @override
  List<Object> get props => [];
}

final class ActiveOrderInitial extends ActiveOrderState {}
