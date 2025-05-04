part of 'account_details_bloc.dart';

enum AccountDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class AccountDetailsState extends Equatable {
  final AccountDetailsStatus status;
  final String? errorMessage;
  final AccountDetailsResponse? accountDetails;

  const AccountDetailsState({
    this.status = AccountDetailsStatus.initial,
    this.errorMessage,
    this.accountDetails,
  });

  AccountDetailsState copyWith({
    AccountDetailsStatus? status,
    String? errorMessage,
    AccountDetailsResponse? accountDetails,
  }) {
    return AccountDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      accountDetails: accountDetails ?? this.accountDetails,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        accountDetails ?? '',
      ];
}
