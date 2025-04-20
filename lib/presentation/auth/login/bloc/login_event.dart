part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class sendOTPEvent extends LoginEvent {
  final String number;

  sendOTPEvent({required this.number});

  @override
  List<Object> get props => [number];
}
