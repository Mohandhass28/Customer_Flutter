class CustomerDetailsParams {
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String gender;

  const CustomerDetailsParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'gender': gender,
    };
  }
}
