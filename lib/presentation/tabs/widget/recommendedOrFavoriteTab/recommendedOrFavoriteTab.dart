import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class Recommendedorfavoritetab extends StatefulWidget {
  Recommendedorfavoritetab({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  String activeTab;
  final Function(String) onTabChanged;

  @override
  State<Recommendedorfavoritetab> createState() =>
      _RecommendedorfavoritetabState();
}

class _RecommendedorfavoritetabState extends State<Recommendedorfavoritetab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
          ),
          onPressed: () {
            widget.onTabChanged("Shop");
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.activeTab == "Shop"
                    ? AppColor.secondaryColor
                    : Colors.transparent,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.only(
              right: 30,
              left: 30,
              top: 3,
              bottom: 3,
            ),
            child: Center(
              child: Text(
                "Shop",
                style: TextStyle(
                  color: widget.activeTab == "Shop"
                      ? AppColor.primaryColor
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onTabChanged("Products");
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.activeTab == "Products"
                    ? AppColor.primaryColor
                    : Colors.transparent,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.only(
              right: 30,
              left: 30,
              top: 3,
              bottom: 3,
            ),
            child: Center(
              child: Text(
                "Products",
                style: TextStyle(
                  color: widget.activeTab == "Products"
                      ? AppColor.primaryColor
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
