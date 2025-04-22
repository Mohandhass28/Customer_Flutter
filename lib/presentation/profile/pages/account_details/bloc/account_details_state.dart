part of 'account_details_bloc.dart';

sealed class AccountDetailsState extends Equatable {
  const AccountDetailsState();
  
  @override
  List<Object> get props => [];
}

final class AccountDetailsInitial extends AccountDetailsState {}
