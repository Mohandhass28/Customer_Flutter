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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bill Total: ₹400.51"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30,
          children: [
            TextButton.icon(
              icon: Icon(
                Icons.account_balance,
                fill: 1,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                _razorpayService.makePayment(
                    400.51, 'ORDER_${DateTime.now().millisecondsSinceEpoch}');
              },
              label: Text(
                "Pay Online",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text("Pay on delivery", style: TextStyle(fontSize: 16)),
            ),
            TextButton.icon(
              icon: Icon(
                Icons.payment,
                fill: 1,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                _makeOrder(context);
              },
              label: Text(
                "Pay on delivery",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }
}
