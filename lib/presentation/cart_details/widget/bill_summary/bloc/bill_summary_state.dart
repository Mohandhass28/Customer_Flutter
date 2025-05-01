part of 'bill_summary_bloc.dart';

enum BillSummaryStatus {
  initial,
  loading,
  success,
  failure,
}

class BillSummaryState extends Equatable {
  final BillSummaryStatus status;
  final String? errorMessage;
  final CartDetailsResponseModel? cartDetails;

  const BillSummaryState({
    this.status = BillSummaryStatus.initial,
    this.errorMessage,
    this.cartDetails,
  });

  BillSummaryState copyWith({
    BillSummaryStatus? status,
    String? errorMessage,
    CartDetailsResponseModel? cartDetails,
  }) {
    return BillSummaryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      cartDetails: cartDetails ?? this.cartDetails,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        cartDetails ?? '',
      ];
}
