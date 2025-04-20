class SendOTPResponse {
  final int status;
  final String message;
  final int otp;

  SendOTPResponse({
    required this.status,
    required this.message,
    required this.otp,
  });

  factory SendOTPResponse.fromJson(Map<String, dynamic> json) {
    return SendOTPResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      otp: json['otp'] ?? 0,
    );
  }
}
