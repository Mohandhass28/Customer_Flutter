class WishListResponse {
  final int status;
  final String msg;

  const WishListResponse({
    required this.status,
    required this.msg,
  });

  factory WishListResponse.fromJson(Map<String, dynamic> json) {
    return WishListResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
    };
  }
}
