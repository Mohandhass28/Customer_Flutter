import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreviousOrdersIssuesPage extends StatelessWidget {
  const PreviousOrdersIssuesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Issues with previous orders",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildOrderIssueCard(
              "Order Delivery Delay",
              "If your order is taking longer than expected, please check the tracking information or contact customer support.",
            ),
            _buildOrderIssueCard(
              "Wrong Items Received",
              "If you received incorrect items, please take a photo and contact customer support within 24 hours of delivery.",
            ),
            _buildOrderIssueCard(
              "Order Cancellation",
              "To cancel an order, go to your order details and select 'Cancel Order'. Note that cancellation may not be possible once the order is being prepared.",
            ),
            _buildOrderIssueCard(
              "Refund Status",
              "Refunds typically take 5-7 business days to process. You can check the status in your order history.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderIssueCard(String title, String description) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
