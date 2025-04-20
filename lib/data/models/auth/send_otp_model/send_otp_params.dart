class SendOTPParams {
  final String number;

  SendOTPParams({
    required this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': number,
    };
  }
}
