import 'package:customer/data/models/auth/verify_otp_model/user_model.dart';

class LoginResponse {
  final int status;
  final String message;
  final Payload? payload;

  LoginResponse({
    required this.status,
    required this.message,
    this.payload,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 0,
      message: json['msg'] ?? '',
      payload:
          json['payload'] != null ? Payload.fromJson(json['payload']) : null,
    );
  }
}

class Payload {
  final UserModel? user;
  final String token;
  final String tokenType;

  Payload({
    this.user,
    required this.token,
    required this.tokenType,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'] ?? '',
      tokenType: json['tokenType'] ?? '',
    );
  }
}
