import 'package:customer/domain/cart/entities/cart_details/cart_details_entity.dart';

class CartDetailsModel extends CartDetailsEntity {
  const CartDetailsModel({
    required super.cartItemCount,
    required super.cartShopCount,
    required super.itemTotal,
    required super.platformFees,
    required super.deliveryDistanceNormalProducts,
    required super.deliveryDistanceHeavyProducts,
    required super.deliveryFeesNormalProducts,
    required super.deliveryFeesHeavyProducts,
    required super.gstTotal,
    required super.cgstTotal,
    required super.sgstTotal,
    required super.cessTotal,
    required super.totalAmount,
    required super.cashHandlingCharges,
    required super.paymentGatewayCharges,
    required super.finalAmount,
  });

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) {
    return CartDetailsModel(
      cartItemCount: json['cart_item_count'] ?? 0,
      cartShopCount: json['cart_shop_count'] ?? 0,
      itemTotal: (json['item_total'] ?? 0).toDouble(),
      platformFees: (json['platform_fees'] ?? 0).toDouble(),
      deliveryDistanceNormalProducts:
          (json['delivery_distance_normal_products'] ?? 0).toDouble(),
      deliveryDistanceHeavyProducts:
          (json['delivery_distance_heavy_products'] ?? 0).toDouble(),
      deliveryFeesNormalProducts:
          (json['delivery_fees_normal_products'] ?? 0).toDouble(),
      deliveryFeesHeavyProducts:
          (json['delivery_fees_heavy_products'] ?? 0).toDouble(),
      gstTotal: (json['gst_total'] ?? 0).toDouble(),
      cgstTotal: (json['cgst_total'] ?? 0).toDouble(),
      sgstTotal: (json['sgst_total'] ?? 0).toDouble(),
      cessTotal: (json['cess_total'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      cashHandlingCharges: (json['cash_handling_charges'] ?? 0).toDouble(),
      paymentGatewayCharges: (json['payment_gateway_charges'] ?? 0).toDouble(),
      finalAmount: (json['final_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_count': cartItemCount,
      'cart_shop_count': cartShopCount,
      'item_total': itemTotal,
      'platform_fees': platformFees,
      'delivery_distance_normal_products': deliveryDistanceNormalProducts,
      'delivery_distance_heavy_products': deliveryDistanceHeavyProducts,
      'delivery_fees_normal_products': deliveryFeesNormalProducts,
      'delivery_fees_heavy_products': deliveryFeesHeavyProducts,
      'gst_total': gstTotal,
      'cgst_total': cgstTotal,
      'sgst_total': sgstTotal,
      'cess_total': cessTotal,
      'total_amount': totalAmount,
      'cash_handling_charges': cashHandlingCharges,
      'payment_gateway_charges': paymentGatewayCharges,
      'final_amount': finalAmount,
    };
  }
}
