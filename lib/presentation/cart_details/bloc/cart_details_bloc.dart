import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_details_event.dart';
part 'cart_details_state.dart';

class CartDetailsBloc extends Bloc<CartDetailsEvent, CartDetailsState> {
  CartDetailsBloc() : super(CartDetailsInitial()) {
    on<CartDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
