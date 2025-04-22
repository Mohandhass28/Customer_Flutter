import 'package:bloc/bloc.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_model.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SendOTPUseCase _sendOTPUseCase;

  LoginBloc({
    required SendOTPUseCase sendOTPUseCase,
  })  : _sendOTPUseCase = sendOTPUseCase,
        super(LoginState()) {
    on<sendOTPEvent>(_onSendOTPEvent);
  }
  Future<void> _onSendOTPEvent(
      sendOTPEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _sendOTPUseCase(SendOTPParams(number: event.number));

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (sendOTPModel) {
        emit(
          state.copyWith(
            status: LoginStatus.success,
            sendOTPModel: sendOTPModel as SendOTPModel,
          ),
        );
      },
    );
  }
}
