part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final CustomerDetailsParams params;
  final BuildContext? context;

  const UpdateProfileEvent({
    required this.params,
    this.context,
  });

  @override
  List<Object> get props => [params];
}
