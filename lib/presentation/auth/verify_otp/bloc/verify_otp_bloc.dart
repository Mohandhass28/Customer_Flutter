import 'package:bloc/bloc.dart';
import 'package:customer/data/models/auth/send_otp_model/send_otp_params.dart';
import 'package:customer/data/models/auth/verify_otp_model/verify_otp.dart';
import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';
import 'package:customer/domain/auth/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOTPUseCase _verifyOTPUseCase;

  VerifyOtpBloc({required VerifyOTPUseCase verifyOTPUseCase})
      : _verifyOTPUseCase = verifyOTPUseCase,
        super(VerifyOtpState()) {
    on<VerifyOtpEvent>(_onVerifyOTPEvent);
  }
  _onVerifyOTPEvent(VerifyOtpEvent event, Emitter<VerifyOtpState> emit) async {
    emit(state.copyWith(status: VerifyOtpStatus.loading));

    final result = await _verifyOTPUseCase(
      VerifyOtpParams(
        phone: event.number,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: VerifyOtpStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(
          state.copyWith(
            status: VerifyOtpStatus.success,
            user: user as UserModel,
          ),
        );
      },
    );
  }
}
