part of 'splash_bloc.dart';

enum SplashStatus {
  initial,
  loading,
  success,
  failure,
}

final class SplashState extends Equatable {
  final bool isAuthenticated;
  final SplashStatus status;
  final String? errorMessage;

  const SplashState({
    this.errorMessage,
    this.status = SplashStatus.initial,
    this.isAuthenticated = false,
  });

  SplashState copyWith({
    bool? isAuthenticated,
    SplashStatus? status,
    String? errorMessage,
  }) {
    return SplashState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        isAuthenticated,
        status,
        errorMessage ?? '',
      ];
}
