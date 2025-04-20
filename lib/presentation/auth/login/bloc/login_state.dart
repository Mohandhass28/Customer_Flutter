part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.sendOTPModel,
  });

  final LoginStatus status;
  final String? errorMessage;
  final SendOTPModel? sendOTPModel;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    SendOTPModel? sendOTPModel,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sendOTPModel: sendOTPModel ?? this.sendOTPModel,
    );
  }

  @override
  List<Object> get props => [status, errorMessage ?? '', sendOTPModel ?? ''];
}
