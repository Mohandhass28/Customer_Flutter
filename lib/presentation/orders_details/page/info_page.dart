import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order #172637281938",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "View Details    04:07 PM",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildLocationSection(),
            _buildBillDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        _buildLocationItem(
          "Cold Stone Creamery",
          "Miraya Rose",
          isFirst: true,
        ),
        _buildLocationItem(
          "Denzong Kitchen",
          "Tollygunge",
        ),
        _buildLocationItem(
          "Rishabh's House",
          "G/13/02 Platinum city yeshwanthpur bangalore -560022",
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildLocationItem(String title, String subtitle,
      {bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(width: 16),
          Column(
            children: [
              Icon(Icons.location_on, color: Colors.green.shade900),
              if (!isLast)
                Expanded(
                  child: VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
            ],
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
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade900,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bill Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildRestaurantItems(
          "Cold Stone Creamery",
          [
            "French Vanilla x 1",
            "Chocolate Waffles x 1",
            "Vanilla pinenut x 1",
          ],
        ),
        _buildRestaurantItems(
          "Denzong Kitchen",
          [
            "Paneer Chilli x 1",
            "Dragon Chicken x 1",
          ],
          isSecond: true,
        ),
        Divider(),
        _buildBillItem("Item total", "₹345"),
        _buildBillItem("Taxes", "₹82.50"),
        _buildBillItem("Delivery Charge", "₹20"),
        _buildBillItem("Restaurant Packing Charges", "₹4.24"),
        _buildBillItem("Platform Fee", "₹5"),
        Divider(),
        _buildBillItem("Grand Total", "₹452.5", isBold: true),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRestaurantItems(String restaurantName, List<String> items,
      {bool isSecond = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            restaurantName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...items.map((item) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: isSecond && item.contains("Dragon")
                        ? Colors.red
                        : Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(item),
                ],
              ),
            )),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBillItem(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
