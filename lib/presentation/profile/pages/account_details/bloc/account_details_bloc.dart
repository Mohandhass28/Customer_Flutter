import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_details_event.dart';
part 'account_details_state.dart';

class AccountDetailsBloc extends Bloc<AccountDetailsEvent, AccountDetailsState> {
  AccountDetailsBloc() : super(AccountDetailsInitial()) {
    on<AccountDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
