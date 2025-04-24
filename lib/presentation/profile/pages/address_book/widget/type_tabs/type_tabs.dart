import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class TypeTabs extends StatefulWidget {
  const TypeTabs({
    super.key,
    required this.onTabChanged,
    this.initialTab = "Home",
  });
  final Function(String) onTabChanged;
  final String initialTab;
  @override
  State<TypeTabs> createState() => _TypeTabsState();
}

class _TypeTabsState extends State<TypeTabs> {
  late String activeTab = "Home";
  @override
  void initState() {
    super.initState();
    activeTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTab(
          "Home",
          activeTab == "Home",
        ),
        _buildTab(
          "Work",
          activeTab == "Work",
        ),
        _buildTab(
          "Hotel",
          activeTab == "Hotel",
        ),
      ],
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      constraints: BoxConstraints(minWidth: 50, maxHeight: 30),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
          ),
          onPressed: () {
            setState(() {
              activeTab = text;
            });
            widget.onTabChanged(text);
          },
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColor.primaryColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
