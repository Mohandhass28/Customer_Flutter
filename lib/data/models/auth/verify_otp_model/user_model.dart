import 'package:customer/domain/auth/entities/user.dart';

class UserModel extends User {
  final String? emailVerifiedAt;
  final String? phone;
  final String? dob;
  final String? location;
  final String? address;
  final String? image;
  final String? gender;
  final bool? status;
  final String? userRoleId;
  final String? gstin;
  final bool? gstinVerification;
  final bool? isDeliveryPerson;
  final String? cityId;
  final String? stateId;
  final String? pincode;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String? kycFile;
  final int? isPhoneVerified;
  final int? isEmailVerified;
  final String? dateOfJoinning;
  final int? isOnline;
  final int? isVerified;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    required String id,
    required String name,
    required String email,
    this.emailVerifiedAt,
    this.phone,
    this.dob,
    this.location,
    this.address,
    this.image,
    this.gender,
    this.status,
    this.userRoleId,
    this.gstin,
    this.gstinVerification,
    this.isDeliveryPerson,
    this.cityId,
    this.stateId,
    this.pincode,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.kycFile,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.dateOfJoinning,
    this.isOnline,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          name: name,
          email: email,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      phone: json['phone'],
      dob: json['dob'],
      location: json['location'],
      address: json['address'],
      image: json['image'],
      gender: json['gender'],
      status: json['status'],
      userRoleId: json['user_role_id'],
      gstin: json['gstin'],
      gstinVerification: json['gstin_verification'],
      isDeliveryPerson: json['is_delivery_person'],
      cityId: json['city_id'],
      stateId: json['state_id'],
      pincode: json['pincode'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      addressLine3: json['address_line3'],
      kycFile: json['kyc_file'],
      isPhoneVerified: json['is_phone_verified'],
      isEmailVerified: json['is_email_verified'],
      dateOfJoinning: json['date_of_joinning'],
      isOnline: json['is_online'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone': phone,
      'dob': dob,
      'location': location,
      'address': address,
      'image': image,
      'gender': gender,
      'status': status,
      'user_role_id': userRoleId,
      'gstin': gstin,
      'gstin_verification': gstinVerification,
      'is_delivery_person': isDeliveryPerson,
      'city_id': cityId,
      'state_id': stateId,
      'pincode': pincode,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'address_line3': addressLine3,
      'kyc_file': kycFile,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
      'date_of_joinning': dateOfJoinning,
      'is_online': isOnline,
      'is_verified': isVerified,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
