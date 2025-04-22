part of 'past_orders_bloc.dart';

sealed class PastOrdersState extends Equatable {
  const PastOrdersState();
  
  @override
  List<Object> get props => [];
}

final class PastOrdersInitial extends PastOrdersState {}
