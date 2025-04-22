import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int id;
  final String type;
  final String receiverName;
  final String receiverContact;
  final String address;
  final String areaSector;
  final String latitude;
  final String longitude;
  final int isDefault;
  final bool status;

  const AddressEntity({
    required this.id,
    required this.type,
    required this.receiverName,
    required this.receiverContact,
    required this.address,
    required this.areaSector,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.status,
  });

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
