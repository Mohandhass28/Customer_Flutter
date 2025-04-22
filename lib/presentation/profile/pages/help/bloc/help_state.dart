part of 'help_bloc.dart';

sealed class HelpState extends Equatable {
  const HelpState();
  
  @override
  List<Object> get props => [];
}

final class HelpInitial extends HelpState {}
