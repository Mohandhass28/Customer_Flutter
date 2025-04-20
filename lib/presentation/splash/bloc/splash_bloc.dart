import 'package:bloc/bloc.dart';
import 'package:customer/domain/auth/usecases/auth_check_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthCheckUseCase _authCheckUseCase;

  SplashBloc({required AuthCheckUseCase authCheckUseCase})
      : _authCheckUseCase = authCheckUseCase,
        super(SplashState()) {
    on<AppStartEvent>(_onAppStartEvent);
  }

  Future<void> _onAppStartEvent(
      AppStartEvent event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loading));

    // Add a small delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is authenticated
    final result = await _authCheckUseCase();

    result.fold(
      (failure) {
        // If there's an error, assume user is not authenticated
        emit(state.copyWith(
          status: SplashStatus.failure,
          errorMessage: failure.message,
          isAuthenticated: false,
        ));
      },
      (isAuthenticated) {
        emit(state.copyWith(
          status: SplashStatus.success,
          isAuthenticated: isAuthenticated,
        ));
      },
    );
  }
}
