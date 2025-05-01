import 'package:flutter/material.dart';
import 'package:customer/core/config/theme/app_color.dart';
import '../widget/notification_icon.dart';
import '../widget/direct_svg_icon.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Toggle between different icon implementations
  bool useDirectSvg = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NotificationIcon(
                size: 150,
                color: AppColor.primaryColor,
              ),

              // Add a button to toggle between implementations
              // TextButton(
              //   onPressed: () {
              //     setState(() {
              //       useDirectSvg = !useDirectSvg;
              //     });
              //   },
              //   child: Text(
              //     useDirectSvg
              //         ? "Try Asset Approach"
              //         : "Try Direct File Approach",
              //     style: TextStyle(color: AppColor.primaryColor),
              //   ),
              // ),
              SizedBox(height: 30),
              Text(
                "No Notifications Yet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "You have no recent notifications yet. When you get notifications, they'll show up here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40),
              // Optional: Add a refresh button
              ElevatedButton(
                onPressed: () {
                  // Refresh logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Refreshing notifications...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Refresh",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
