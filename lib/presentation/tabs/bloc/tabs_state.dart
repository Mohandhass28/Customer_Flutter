part of 'tabs_bloc.dart';

enum TabsStatus {
  initial,
  loading,
  success,
  failure,
}

class TabsState extends Equatable {
  final TabsStatus status;
  final String? errorMessage;

  const TabsState({
    this.status = TabsStatus.initial,
    this.errorMessage,
  });

  TabsState copyWith({
    TabsStatus? status,
    String? errorMessage,
  }) {
    return TabsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
      ];
}
