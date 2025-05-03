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
    // Using the most basic configuration to minimize potential issues
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Different test key
      'amount':
          (amount * 100).toInt(), // Amount in smallest currency unit (paise)
      'name': 'Your Store',
      'description': 'Test Payment',
      'prefill': {'contact': '9999999999', 'email': 'test@example.com'},
      'currency': 'INR',
    };

    try {
      debugPrint('Opening Razorpay with options: $options');
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      debugPrint('Error details: ${e.toString()}');
      _showErrorDialog('Failed to open payment gateway: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment successful
    debugPrint("Payment Successful");
    debugPrint("Payment ID: ${response.paymentId}");
    debugPrint("Order ID: ${response.orderId}");
    debugPrint("Signature: ${response.signature}");

    // Show success message before navigating
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text('Payment successful!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to order details page after a short delay
    // Using a variable to capture the context to avoid async gap issues
    final context = _context;
    Future.delayed(Duration(seconds: 1), () {
      if (context.mounted) {
        context.push("/order-details");
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    debugPrint("Payment Failed");
    debugPrint("Code: ${response.code}");
    debugPrint("Message: ${response.message}");
    debugPrint("Error: ${response.error.toString()}");

    // Detailed error message based on error code
    String errorMessage = 'Payment failed';

    switch (response.code) {
      case 1:
        errorMessage = 'Payment cancelled by user';
        break;
      case 2:
        errorMessage = 'Transaction failed. Please try again.';
        break;
      default:
        errorMessage =
            'Payment failed: ${response.message ?? response.error?.toString() ?? "Unknown error"}';
    }

    // Show error message
    _showErrorDialog(errorMessage);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    debugPrint("External Wallet Selected");
    debugPrint("Wallet Name: ${response.walletName}");

    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    _razorpay.clear();
  }
}
