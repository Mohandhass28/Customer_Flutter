part of 'account_details_bloc.dart';

sealed class AccountDetailsEvent extends Equatable {
  const AccountDetailsEvent();

  @override
  List<Object> get props => [];
}

class AddAccountDetailsEvent extends AccountDetailsEvent {
  final AccountDetailsParams params;
  const AddAccountDetailsEvent({required this.params});

  @override
  List<Object> get props => [
        params,
      ];
}
