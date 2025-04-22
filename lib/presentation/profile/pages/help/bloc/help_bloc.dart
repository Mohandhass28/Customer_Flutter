import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'help_event.dart';
part 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  HelpBloc() : super(HelpInitial()) {
    on<HelpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
