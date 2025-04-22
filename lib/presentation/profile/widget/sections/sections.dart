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
          color: const Color.fromARGB(87, 158, 158, 158),
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Opacity(
        opacity: widget.isEnable ? 1 : 0.3,
        child: TextButton(
          onPressed: widget.onPressed,
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
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
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(172, 182, 182, 182),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
