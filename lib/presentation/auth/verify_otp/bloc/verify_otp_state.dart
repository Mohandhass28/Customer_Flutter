part of 'verify_otp_bloc.dart';

enum VerifyOtpStatus {
  initial,
  loading,
  success,
  failure,
}

class VerifyOtpState extends Equatable {
  final VerifyOtpStatus status;
  final String? errorMessage;
  final UserModel? user;
  const VerifyOtpState({
    this.status = VerifyOtpStatus.initial,
    this.errorMessage,
    this.user,
  });

  VerifyOtpState copyWith({
    VerifyOtpStatus? status,
    String? errorMessage,
    UserModel? user,
  }) {
    return VerifyOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        user ?? '',
      ];
}
