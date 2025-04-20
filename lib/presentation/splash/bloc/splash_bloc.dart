import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<AppStartEvent>(_onAppStartEvent);
  }

  _onAppStartEvent(AppStartEvent event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loading));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(status: SplashStatus.success, isAuthenticated: true));
  }
}
