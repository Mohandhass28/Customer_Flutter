part of 'tabs_bloc.dart';

sealed class TabsState extends Equatable {
  const TabsState();
  
  @override
  List<Object> get props => [];
}

final class TabsInitial extends TabsState {}
