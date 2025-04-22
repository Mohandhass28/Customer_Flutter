part of 'verify_otp_bloc.dart';

class VerifyOtpEvent extends Equatable {
  final String number;
  final String otp;

  VerifyOtpEvent({required this.number, required this.otp});

  @override
  List<Object> get props => [];
}
