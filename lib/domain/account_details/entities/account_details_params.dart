import 'package:equatable/equatable.dart';

class AccountDetailsParams extends Equatable {
  final String accountNo;
  final String bankName;
  final String ifscCode;

  const AccountDetailsParams({
    required this.accountNo,
    required this.bankName,
    required this.ifscCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_no': accountNo,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
    };
  }

  @override
  List<Object> get props => [accountNo, bankName, ifscCode];
}
