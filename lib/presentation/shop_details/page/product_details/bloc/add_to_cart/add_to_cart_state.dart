part of 'add_to_cart_bloc.dart';

enum AddToCartStatus {
  initial,
  loading,
  success,
  failure,
}

class AddToCartState extends Equatable {
  final AddToCartStatus status;
  final String? errorMessage;
  final AddToCartSuccessResponseModel? addToCartResponse;

  const AddToCartState({
    this.status = AddToCartStatus.initial,
    this.errorMessage,
    this.addToCartResponse,
  });

  AddToCartState copyWith({
    AddToCartStatus? status,
    String? errorMessage,
    AddToCartSuccessResponseModel? addToCartResponse,
  }) {
    return AddToCartState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      addToCartResponse: addToCartResponse ?? this.addToCartResponse,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        addToCartResponse ?? '',
      ];
}
