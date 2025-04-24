part of 'address_book_bloc.dart';

sealed class AddressBookEvent extends Equatable {
  const AddressBookEvent();

  @override
  List<Object> get props => [];
}

class GetAddressListEvent extends AddressBookEvent {
  final AddressParam addressParam;
  const GetAddressListEvent({required this.addressParam});

  @override
  List<Object> get props => [];
}

class SetDefaultAddressEvent extends AddressBookEvent {
  final int addressId;
  const SetDefaultAddressEvent({required this.addressId});

  @override
  List<Object> get props => [];
}

class CreateAddressEvent extends AddressBookEvent {
  final CreateAddressEntity createAddressEntity;
  const CreateAddressEvent({required this.createAddressEntity});

  @override
  List<Object> get props => [];
}
