import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BillSummary extends StatefulWidget {
  const BillSummary({super.key});

  @override
  State<BillSummary> createState() => _BillSummaryState();
}

class _BillSummaryState extends State<BillSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bill Summary",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      Text("Item Total")
                    ],
                  ),
                  Text("₹300")
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Delivery Fee"),
                  IconButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: 35,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fire_truck_rounded,
                      ),
                      Text("Delivery Fee for 0 km with heavy Vehicle"),
                    ],
                  ),
                  Text("₹80"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Tax and other charges"),
                      IconButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_up,
                          size: 35,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text("₹80"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.mobile_screen_share),
                      Text("Platform charges"),
                    ],
                  ),
                  Text("₹80"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.money),
                      Text("Payment Gateway charges"),
                    ],
                  ),
                  Text("₹80"),
                ],
              ),
              Row(
                children: [
                  Text("Taxes"),
                  IconButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: 35,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
