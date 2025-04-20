import 'package:equatable/equatable.dart';

class SendOTP extends Equatable {
  final int status;
  final String message;
  final int otp;

  SendOTP({
    required this.status,
    required this.message,
    required this.otp,
  });

  @override
  List<Object> get props => [status, message, otp];
}
