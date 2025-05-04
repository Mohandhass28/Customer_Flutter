import 'package:customer/core/utils/index.dart';
import 'package:customer/domain/auth/usecases/logout_usecase.dart';
import 'package:customer/presentation/profile/pages/user_details/bloc/profile_bloc.dart';
import 'package:customer/presentation/profile/widget/sections/sections.dart';
import 'package:customer/presentation/profile/widget/user_details/user_details.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              icon: Icons.update_outlined,
              text: "App Update available",
              onPressed: () {},
            ),
            Sections(
              icon: Icons.notifications_outlined,
              text: "Notifications",
              onPressed: () {
                context.push('/notifications');
              },
            ),
            Sections(
              icon: Icons.person_outlined,
              text: "Refer & Earn program",
              isEnable: false,
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Food Orders",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: const Color.fromARGB(191, 23, 23, 23),
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
              icon: Icons.book_outlined,
              text: "Address Book",
              onPressed: () {
                context.push('/address-book');
              },
            ),
            Sections(
              icon: Icons.question_answer_outlined,
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
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: const Color.fromARGB(191, 23, 23, 23),
                ),
              ),
            ),
            Sections(
              icon: Icons.wallet_outlined,
              text: "Wallet",
              onPressed: () {
                context.push('/wallet');
              },
            ),
            Sections(
              icon: Icons.account_balance_outlined,
              text: "Account Details",
              onPressed: () {
                context.push('/address-details');
              },
            ),
            Sections(
              icon: Icons.question_answer_outlined,
              text: "About",
              onPressed: () {
                context.push('/about');
              },
            ),
            Sections(
              icon: Icons.logout_outlined,
              text: "Logout",
              onPressed: () async {
                final result = await sl<LogoutUseCase>().call();
                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.message)),
                    );
                  },
                  (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout successful')),
                    );
                    AlertMessage.show(
                      context,
                      title: 'Logout',
                      message: 'You have been logged out successfully.',
                      onOkPressed: () {
                        context.go('/login');
                      },
                      onCancelPressed: () {
                        // No additional action needed
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
