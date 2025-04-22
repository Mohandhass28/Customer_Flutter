import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'orders_details_event.dart';
part 'orders_details_state.dart';

class OrdersDetailsBloc extends Bloc<OrdersDetailsEvent, OrdersDetailsState> {
  OrdersDetailsBloc() : super(OrdersDetailsInitial()) {
    on<OrdersDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
