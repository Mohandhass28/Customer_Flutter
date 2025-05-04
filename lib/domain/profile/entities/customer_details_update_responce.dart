class CustomerDetailsUpdateResponseEntity {
  final int status;
  final String msg;

  const CustomerDetailsUpdateResponseEntity({
    required this.status,
    required this.msg,
  });
  factory CustomerDetailsUpdateResponseEntity.fromJson(
      Map<String, dynamic> json) {
    return CustomerDetailsUpdateResponseEntity(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }
}
