import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tabs_event.dart';
part 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  TabsBloc() : super(TabsInitial()) {
    on<TabsEvent>((event, emit) {});
  }
}
