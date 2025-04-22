import 'package:customer/domain/address/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.type,
    required super.receiverName,
    required super.receiverContact,
    required super.address,
    required super.areaSector,
    required super.latitude,
    required super.longitude,
    required super.isDefault,
    required super.status,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      receiverContact: json['receiver_contact'] ?? '',
      address: json['address'] ?? '',
      areaSector: json['area_sector'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      isDefault: json['is_default'] ?? 0,
      status: json['status'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'receiver_name': receiverName,
      'receiver_contact': receiverContact,
      'address': address,
      'area_sector': areaSector,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'status': status,
    };
  }

  AddressModel copyWith({
    int? id,
    String? type,
    String? receiverName,
    String? receiverContact,
    String? address,
    String? areaSector,
    String? latitude,
    String? longitude,
    int? isDefault,
    bool? status,
  }) {
    return AddressModel(
      id: id ?? this.id,
      type: type ?? this.type,
      receiverName: receiverName ?? this.receiverName,
      receiverContact: receiverContact ?? this.receiverContact,
      address: address ?? this.address,
      areaSector: areaSector ?? this.areaSector,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        id,
        type,
        receiverName,
        receiverContact,
        address,
        areaSector,
        latitude,
        longitude,
        isDefault,
        status,
      ];
}
