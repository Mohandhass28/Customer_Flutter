part of 'cart_details_bloc.dart';

sealed class CartDetailsState extends Equatable {
  const CartDetailsState();
  
  @override
  List<Object> get props => [];
}

final class CartDetailsInitial extends CartDetailsState {}
