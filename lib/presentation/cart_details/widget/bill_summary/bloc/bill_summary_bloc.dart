import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bill_summary_event.dart';
part 'bill_summary_state.dart';

class BillSummaryBloc extends Bloc<BillSummaryEvent, BillSummaryState> {
  BillSummaryBloc() : super(BillSummaryInitial()) {
    on<BillSummaryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
