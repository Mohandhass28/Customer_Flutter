part of 'tabs_bloc.dart';

sealed class TabsEvent extends Equatable {
  const TabsEvent();

  @override
  List<Object> get props => [];
}

class setDefaultAddressEvent extends TabsEvent {
  final CreateAddressEntity params;
  const setDefaultAddressEvent({required this.params});

  @override
  List<Object> get props => [];
}
