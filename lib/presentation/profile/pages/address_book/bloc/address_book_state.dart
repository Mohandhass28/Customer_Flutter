part of 'address_book_bloc.dart';

enum AddressBookStatus {
  initial,
  loading,
  success,
  failure,
}

class AddressList {
  final List<AddressModel> addressList;
  final AddressBookStatus status;
  final String? errorMessage;

  const AddressList({
    this.addressList = const [],
    this.status = AddressBookStatus.initial,
    this.errorMessage,
  });

  AddressList copyWith({
    List<AddressModel>? addressList,
    AddressBookStatus? status,
    String? errorMessage,
  }) {
    return AddressList(
      addressList: addressList ?? this.addressList,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
