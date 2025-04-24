part of 'address_header_bloc.dart';

enum AddressHeaderStatus {
  initial,
  loading,
  success,
  failure,
}

class AddressHeaderState extends Equatable {
  final AddressHeaderStatus status;
  final String? errorMessage;
  final AddressModel? address;

  const AddressHeaderState({
    this.status = AddressHeaderStatus.initial,
    this.errorMessage,
    this.address,
  });

  AddressHeaderState copyWith({
    AddressHeaderStatus? status,
    String? errorMessage,
    AddressModel? address,
  }) {
    return AddressHeaderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      address: address ?? this.address,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        address ?? '',
      ];
}
