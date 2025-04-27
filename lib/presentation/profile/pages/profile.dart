import 'package:customer/presentation/profile/widget/sections/sections.dart';
import 'package:customer/presentation/profile/widget/user_details/user_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            UserDetails(),
            SizedBox(height: 20),
            Sections(
              icon: Icons.update,
              text: "App Update available",
              onPressed: () {},
            ),
            Sections(
              icon: Icons.notifications,
              text: "Notifications",
              onPressed: () {
                context.push('/notifications');
              },
            ),
            Sections(
              icon: Icons.person,
              text: "Refer & Earn program",
              isEnable: false,
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Food Orders",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Sections(
              icon: Icons.edit_document,
              text: "Past Orders",
              onPressed: () {
                context.push('/past-orders');
              },
            ),
            Sections(
              icon: Icons.book,
              text: "Address Book",
              onPressed: () {
                context.push('/address-book');
              },
            ),
            Sections(
              icon: Icons.question_answer,
              text: "Help",
              onPressed: () {
                context.push('/help');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "More",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Sections(
              icon: Icons.wallet,
              text: "Wallet",
              onPressed: () {
                context.push('/wallet');
              },
            ),
            Sections(
              icon: Icons.account_balance,
              text: "Account Details",
              onPressed: () {
                context.push('/address-details');
              },
            ),
            Sections(
              icon: Icons.question_answer,
              text: "About",
              onPressed: () {
                context.push('/about');
              },
            ),
            Sections(
              icon: Icons.logout,
              text: "Logout",
              onPressed: () {},
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
