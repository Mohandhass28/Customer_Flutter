part of 'billing_bloc.dart';

sealed class BillingState extends Equatable {
  const BillingState();
  
  @override
  List<Object> get props => [];
}

final class BillingInitial extends BillingState {}
