import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActiveOrderPage extends StatefulWidget {
  const ActiveOrderPage({super.key});

  @override
  State<ActiveOrderPage> createState() => _ActiveOrderPageState();
}

class _ActiveOrderPageState extends State<ActiveOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Active Order"),
        ),
        body: Column(
          children: [
            buildActiveOrderCard(),
          ],
        ));
  }

  Widget buildActiveOrderCard() {
    return Card(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            constraints: BoxConstraints(
              minWidth: 140,
              minHeight: 140,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00660A),
                  Color(0xFF02B914),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                "10 min",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 7,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Id: #172637281938",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "View Details    04:07 PM",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  buildActiveOrderButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActiveOrderButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Color(0xFF02B914),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        ),
        minimumSize: WidgetStateProperty.all<Size>(
          Size(double.infinity, 36),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: () {
        context.push('/order-details');
      },
      child: Text(
        "Track your order",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
