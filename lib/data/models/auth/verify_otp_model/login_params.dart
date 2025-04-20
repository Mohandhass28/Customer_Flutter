class LoginParams {
  final String? email;
  final String? phone;
  final String? otp;

  LoginParams({
    this.email,
    this.phone,
    this.otp,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (email != null) {
      data['email'] = email;
    }

    if (phone != null) {
      data['phone'] = phone;
    }

    if (otp != null) {
      data['otp'] = otp;
    }

    return data;
  }
}
