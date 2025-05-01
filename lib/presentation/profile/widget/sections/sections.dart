import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class Sections extends StatefulWidget {
  const Sections({
    super.key,
    required this.icon,
    required this.text,
    this.isEnable = true,
    required this.onPressed,
  });
  final IconData icon;
  final String text;
  final bool isEnable;
  final Function() onPressed;

  @override
  State<Sections> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(56, 158, 158, 158),
          width: 1,
          style: BorderStyle.solid,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Opacity(
        opacity: widget.isEnable ? 1 : 0.3,
        child: TextButton(
          onPressed: widget.onPressed,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              AppColor.primaryColor.withOpacity(0.1),
            ),
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 14,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(141, 184, 184, 184),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(227, 90, 88, 88),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: const Color.fromARGB(255, 115, 114, 114),
              )
            ],
          ),
        ),
      ),
    );
  }
}
