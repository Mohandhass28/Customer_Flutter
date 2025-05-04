import 'package:bloc/bloc.dart';
import 'package:customer/domain/account_details/entities/account_details_params.dart';
import 'package:customer/domain/account_details/entities/account_details_responce.dart';
import 'package:customer/domain/account_details/usecases/add_account_details.dart';
import 'package:equatable/equatable.dart';

part 'account_details_event.dart';
part 'account_details_state.dart';

class AccountDetailsBloc
    extends Bloc<AccountDetailsEvent, AccountDetailsState> {
  final AddAccountDetailsUsecase _addAccountDetailsUsecase;
  AccountDetailsBloc(
      {required AddAccountDetailsUsecase addAccountDetailsUsecase})
      : _addAccountDetailsUsecase = addAccountDetailsUsecase,
        super(AccountDetailsState()) {
    on<AddAccountDetailsEvent>(_addAccountDetails);
  }

  void _addAccountDetails(
    AddAccountDetailsEvent event,
    Emitter<AccountDetailsState> emit,
  ) async {
    emit(state.copyWith(status: AccountDetailsStatus.loading));
    final result = await _addAccountDetailsUsecase(event.params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AccountDetailsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (accountDetails) {
        emit(
          state.copyWith(
            status: AccountDetailsStatus.success,
            accountDetails: accountDetails,
          ),
        );
      },
    );
  }
}
