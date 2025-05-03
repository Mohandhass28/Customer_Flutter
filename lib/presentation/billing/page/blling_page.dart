import 'package:customer/core/config/theme/app_color.dart';
import 'package:customer/core/services/razorpay_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BllingPage extends StatefulWidget {
  const BllingPage({super.key});

  @override
  State<BllingPage> createState() => _BllingPageState();
}

class _BllingPageState extends State<BllingPage> {
  late RazorpayService _razorpayService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _razorpayService.initRazorpay(context);
    });
  }

  void _makeOrder(BuildContext context) {
    context.push("/order-details");
  }

  void _handleTestPayment() {
    setState(() {
      _isLoading = true;
    });

    // Show a success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment Successful"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text("Test payment completed successfully!"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push("/order-details");
              },
              child: Text("Continue"),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _initiatePayment() {
    setState(() {
      _isLoading = true;
    });

    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Initializing payment gateway...")
              ],
            ),
          );
        },
      );

      // Short delay to ensure the dialog is shown
      // Capture the context to avoid async gap issues
      final currentContext = context;
      Future.delayed(Duration(milliseconds: 500), () {
        // Close the loading dialog
        if (currentContext.mounted) Navigator.of(currentContext).pop();

        // Initialize payment
        _razorpayService.makePayment(
            400.51, 'ORDER_${DateTime.now().millisecondsSinceEpoch}');
      });
    } catch (e) {
      // Capture the context to avoid async gap issues
      final currentContext = context;

      // Close the loading dialog if it's open
      if (currentContext.mounted && Navigator.of(currentContext).canPop()) {
        Navigator.of(currentContext).pop();
      }

      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize payment: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bill Total: ₹400.51"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Payment options title
            Text(
              "Payment Options",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            // Online payment option
            _buildPaymentOption(
              icon: Icons.account_balance,
              title: "Pay Online",
              subtitle: "Pay using Credit/Debit Card, UPI, etc.",
              onTap: _isLoading ? null : _initiatePayment,
            ),

            SizedBox(height: 15),

            SizedBox(height: 15),

            // Cash on delivery option
            _buildPaymentOption(
              icon: Icons.payments_outlined,
              title: "Pay on Delivery",
              subtitle: "Pay with cash when your order is delivered",
              onTap: () => _makeOrder(context),
            ),

            SizedBox(height: 30),

            // Order summary
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            // Order summary details
            _buildSummaryItem("Subtotal", "₹380.51"),
            _buildSummaryItem("Delivery Fee", "₹20.00"),
            _buildSummaryItem("Total", "₹400.51", isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: AppColor.primaryColor,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }
}
