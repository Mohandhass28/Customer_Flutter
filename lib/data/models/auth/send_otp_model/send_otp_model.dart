import 'package:customer/domain/auth/entities/send_otp.dart';

class SendOTPModel extends SendOTP {
  SendOTPModel({
    required super.status,
    required super.message,
    required super.otp,
  });

  factory SendOTPModel.fromJson(Map<String, dynamic> json) {
    return SendOTPModel(
      status: json['status'] ?? 0,
      message: json['msg'] ?? '',
      otp: json['otp'] ?? 0,
    );
  }
}
