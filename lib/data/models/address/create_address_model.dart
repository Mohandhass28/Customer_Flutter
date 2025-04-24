import 'package:customer/domain/address/entities/create_address_entity.dart';

class CreateAddressModel extends CreateAddressEntity {
  const CreateAddressModel({
    required super.type,
    required super.receiverName,
    required super.receiverContact,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.areaSector,
    required super.isDefault,
  });

  factory CreateAddressModel.fromJson(Map<String, dynamic> json) {
    return CreateAddressModel(
      type: json['type'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      receiverContact: json['receiver_contact'] ?? 0,
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      areaSector: json['area_sector'] ?? '',
      isDefault: json['is_default'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'receiver_name': receiverName,
      'receiver_contact': receiverContact,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'area_sector': areaSector,
      'is_default': isDefault,
    };
  }

  CreateAddressModel copyWith({
    String? type,
    String? receiverName,
    int? receiverContact,
    String? address,
    String? latitude,
    String? longitude,
    String? areaSector,
    int? isDefault,
  }) {
    return CreateAddressModel(
      type: type ?? this.type,
      receiverName: receiverName ?? this.receiverName,
      receiverContact: receiverContact ?? this.receiverContact,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      areaSector: areaSector ?? this.areaSector,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
