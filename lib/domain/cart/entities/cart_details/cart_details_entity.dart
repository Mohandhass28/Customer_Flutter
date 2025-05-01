import 'package:equatable/equatable.dart';

class CartDetailsEntity extends Equatable {
  final int cartItemCount;
  final int cartShopCount;
  final double itemTotal;
  final double platformFees;
  final double deliveryDistanceNormalProducts;
  final double deliveryDistanceHeavyProducts;
  final double deliveryFeesNormalProducts;
  final double deliveryFeesHeavyProducts;
  final double gstTotal;
  final double cgstTotal;
  final double sgstTotal;
  final double cessTotal;
  final double totalAmount;
  final double cashHandlingCharges;
  final double paymentGatewayCharges;
  final double finalAmount;

  const CartDetailsEntity({
    required this.cartItemCount,
    required this.cartShopCount,
    required this.itemTotal,
    required this.platformFees,
    required this.deliveryDistanceNormalProducts,
    required this.deliveryDistanceHeavyProducts,
    required this.deliveryFeesNormalProducts,
    required this.deliveryFeesHeavyProducts,
    required this.gstTotal,
    required this.cgstTotal,
    required this.sgstTotal,
    required this.cessTotal,
    required this.totalAmount,
    required this.cashHandlingCharges,
    required this.paymentGatewayCharges,
    required this.finalAmount,
  });

  @override
  List<Object?> get props => [
        cartItemCount,
        cartShopCount,
        itemTotal,
        platformFees,
        deliveryDistanceNormalProducts,
        deliveryDistanceHeavyProducts,
        deliveryFeesNormalProducts,
        deliveryFeesHeavyProducts,
        gstTotal,
        cgstTotal,
        sgstTotal,
        cessTotal,
        totalAmount,
        cashHandlingCharges,
        paymentGatewayCharges,
        finalAmount,
      ];
}