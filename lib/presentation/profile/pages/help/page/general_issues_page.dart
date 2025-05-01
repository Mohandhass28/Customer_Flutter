import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GeneralIssuesPage extends StatelessWidget {
  const GeneralIssuesPage({Key? key}) : super(key: key);

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
          "General Issues",
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
            _buildIssueCard(
              "App Crashes",
              "If the app crashes, please try restarting your device and updating to the latest version.",
            ),
            _buildIssueCard(
              "Payment Issues",
              "For payment-related issues, please contact our customer support team.",
            ),
            _buildIssueCard(
              "Account Problems",
              "If you're having trouble with your account, try logging out and logging back in.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueCard(String title, String description) {
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
