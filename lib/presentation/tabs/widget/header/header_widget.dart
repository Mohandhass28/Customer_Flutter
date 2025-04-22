import 'package:customer/core/config/assets/app_images.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: 70,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, .6],
              colors: [
                Color.fromARGB(255, 3, 57, 3),
                Color.fromARGB(255, 3, 112, 3),
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  height: 30,
                  AppImages.TP_logo, // Replace with your logo asset path
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 16),
                margin: EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context.go('/profile');
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 100,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, .6],
              colors: [
                Color.fromARGB(255, 3, 57, 3),
                Color.fromARGB(255, 3, 112, 3),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to address book from home
                  context.push('/home-address-book');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.maps_home_work,
                      color: AppColor.richTextColor,
                      size: 18,
                    ),
                    Text(
                      'Mountain View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 10,
                children: [
                  Text(
                    '123 Main St',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'San Francisco, CA 94105',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "USA Francisco lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
