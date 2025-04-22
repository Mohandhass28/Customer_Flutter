import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class Recommendedorfavoritetab extends StatefulWidget {
  const Recommendedorfavoritetab({super.key});

  @override
  State<Recommendedorfavoritetab> createState() =>
      _RecommendedorfavoritetabState();
}

class _RecommendedorfavoritetabState extends State<Recommendedorfavoritetab> {
  bool recommended = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              recommended = !recommended;
            });
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 150),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    recommended ? AppColor.secondaryColor : Colors.transparent,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.only(
              right: 15,
              left: 15,
              top: 3,
              bottom: 3,
            ),
            child: Center(
              child: Text(
                "Recommended",
                style: TextStyle(
                  color: recommended ? AppColor.secondaryColor : Colors.black,
                ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              recommended = !recommended;
            });
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 150),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    !recommended ? AppColor.secondaryColor : Colors.transparent,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.only(
              right: 15,
              left: 15,
              top: 3,
              bottom: 3,
            ),
            child: Center(
              child: Text(
                "Favorite",
                style: TextStyle(
                  color: !recommended ? AppColor.secondaryColor : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
