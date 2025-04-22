import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shop_details_event.dart';
part 'shop_details_state.dart';

class ShopDetailsBloc extends Bloc<ShopDetailsEvent, ShopDetailsState> {
  ShopDetailsBloc() : super(ShopDetailsInitial()) {
    on<ShopDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
