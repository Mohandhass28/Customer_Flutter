import 'package:equatable/equatable.dart';

class CustomerDetailsResponseEntity extends Equatable {
  final int status;
  final String msg;
  final CustomerDataEntity data;

  const CustomerDetailsResponseEntity({
    required this.status,
    required this.msg,
    required this.data,
  });

  @override
  List<Object?> get props => [status, msg, data];
}

class CustomerDataEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String image;
  final String dob;
  final String gender;
  final int isPhoneVerified;
  final int isEmailVerified;

  const CustomerDataEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.dob,
    required this.gender,
    required this.isPhoneVerified,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        image,
        dob,
        gender,
        isPhoneVerified,
        isEmailVerified,
      ];
}