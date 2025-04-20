part of 'verify_otp_bloc.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();
  
  @override
  List<Object> get props => [];
}

final class VerifyOtpInitial extends VerifyOtpState {}
