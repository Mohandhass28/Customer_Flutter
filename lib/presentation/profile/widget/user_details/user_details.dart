import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(98, 33, 149, 243),
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.person,
              size: 50,
              color: const Color.fromARGB(195, 33, 149, 243),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User Name",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("mohammad@gmail.com"),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(
                    0,
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      size: 15,
                      color: AppColor.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
