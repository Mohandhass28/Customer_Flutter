class WishListProductResponse {
  final int status;
  final String msg;

  const WishListProductResponse({
    required this.status,
    required this.msg,
  });

  factory WishListProductResponse.fromJson(Map<String, dynamic> json) {
    return WishListProductResponse(
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
