part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String? errorMessage;
  final CustomerDetailsResponseEntity? customerDetails;

  const ProfileState(
      {this.status = ProfileStatus.initial,
      this.errorMessage,
      this.customerDetails});

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
    CustomerDetailsResponseEntity? customerDetails,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      customerDetails: customerDetails ?? this.customerDetails,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        customerDetails ?? '',
      ];
}
