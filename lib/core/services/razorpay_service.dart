import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class RazorpayService {
  late Razorpay _razorpay;
  late BuildContext _context;

  void initRazorpay(BuildContext context) {
    _context = context;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void makePayment(double amount, String orderId) {
    var options = {
      'key': 'rzp_test_yaXUQ9vZbfNIxc',
      'amount': (amount * 100).toInt(), // Amount needs to be an integer
      'name': 'Test Merchant',
      'description': 'Order Payment',
      'order_id': orderId,
      'timeout': 300,
      'prefill': {'contact': '9876543210', 'email': 'user@example.com'},
      'theme': {
        'color': '#00660A', // Match your app's theme color
      },
      'retry': {
        'enabled': true,
        'max_count': 1,
      },
      'send_sms_hash': true,
      'currency': 'INR',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment successful
    print("Payment Successful");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    _context.push("/order-details");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    print("Payment Failed");
    print("Code: ${response.code}");
    print("Message: ${response.message}");
    // Add your failure logic here
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    print("External Wallet Selected");
    print("Wallet Name: ${response.walletName}");
    // Add your external wallet logic here
  }

  void dispose() {
    _razorpay.clear();
  }
}
