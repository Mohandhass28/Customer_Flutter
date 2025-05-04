import 'package:equatable/equatable.dart';

class AccountDetailsResponse extends Equatable {
  final int status;
  final String msg;

  const AccountDetailsResponse({
    required this.status,
    required this.msg,
  });

  factory AccountDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AccountDetailsResponse(
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

  @override
  List<Object> get props => [status, msg];
}
