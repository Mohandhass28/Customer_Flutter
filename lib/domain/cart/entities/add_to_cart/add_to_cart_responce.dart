class AddToCartSuccessResponseModel {
  final int status;
  final String msg;

  const AddToCartSuccessResponseModel({
    required this.status,
    required this.msg,
  });

  factory AddToCartSuccessResponseModel.fromJson(Map<String, dynamic> json) {
    return AddToCartSuccessResponseModel(
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
