import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  const ButtonComponent({super.key, required Function() onPressedEvent})
      : _onPressedEvent = onPressedEvent;

  final Function() _onPressedEvent;

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          onPressed: widget._onPressedEvent,
          child: Text(
            "Next",
            style: TextStyle(
              color: AppColor.textColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
