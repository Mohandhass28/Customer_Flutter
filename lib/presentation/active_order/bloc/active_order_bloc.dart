import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'active_order_event.dart';
part 'active_order_state.dart';

class ActiveOrderBloc extends Bloc<ActiveOrderEvent, ActiveOrderState> {
  ActiveOrderBloc() : super(ActiveOrderInitial()) {
    on<ActiveOrderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
