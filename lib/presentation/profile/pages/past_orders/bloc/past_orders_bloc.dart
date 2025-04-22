import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'past_orders_event.dart';
part 'past_orders_state.dart';

class PastOrdersBloc extends Bloc<PastOrdersEvent, PastOrdersState> {
  PastOrdersBloc() : super(PastOrdersInitial()) {
    on<PastOrdersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
