import 'package:equatable/equatable.dart';

class CreateAddressEntity extends Equatable {
  final String type;
  final String receiverName;
  final int receiverContact;
  final String address;
  final String latitude;
  final String longitude;
  final String areaSector;
  final int isDefault;

  const CreateAddressEntity({
    required this.type,
    required this.receiverName,
    required this.receiverContact,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.areaSector,
    required this.isDefault,
  });

  @override
  List<Object> get props => [
        type,
        receiverName,
        receiverContact,
        address,
        latitude,
        longitude,
        areaSector,
        isDefault,
      ];
}
