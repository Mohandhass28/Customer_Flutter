part of 'bill_summary_bloc.dart';

sealed class BillSummaryState extends Equatable {
  const BillSummaryState();
  
  @override
  List<Object> get props => [];
}

final class BillSummaryInitial extends BillSummaryState {}
