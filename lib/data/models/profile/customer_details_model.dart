import 'package:customer/domain/profile/entities/customer_details_entity.dart';

class CustomerDetailsResponseModel extends CustomerDetailsResponseEntity {
  const CustomerDetailsResponseModel({
    required super.status,
    required super.msg,
    required super.data,
  });

  factory CustomerDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsResponseModel(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
      data: CustomerDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': (data as CustomerDataModel).toJson(),
    };
  }
}

class CustomerDataModel extends CustomerDataEntity {
  const CustomerDataModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.image,
    required super.dob,
    required super.gender,
    required super.isPhoneVerified,
    required super.isEmailVerified,
  });

  factory CustomerDataModel.fromJson(Map<String, dynamic> json) {
    return CustomerDataModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      isPhoneVerified: json['is_phone_verified'] ?? 0,
      isEmailVerified: json['is_email_verified'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'dob': dob,
      'gender': gender,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
    };
  }
}