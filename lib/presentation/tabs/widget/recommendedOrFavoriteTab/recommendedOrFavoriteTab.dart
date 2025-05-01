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
          onPressed: () {
            widget.onTabChanged("Recommended");
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 130),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.activeTab == "Recommended"
                    ? AppColor.secondaryColor
                    : Colors.transparent,
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
                  color: widget.activeTab == "Recommended"
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
            widget.onTabChanged("Favorites");
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 130),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.activeTab == "Favorites"
                    ? AppColor.primaryColor
                    : Colors.transparent,
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
                "Favorites",
                style: TextStyle(
                  color: widget.activeTab == "Favorites"
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
