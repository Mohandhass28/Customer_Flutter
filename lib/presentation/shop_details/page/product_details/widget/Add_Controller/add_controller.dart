import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class AddController extends StatefulWidget {
  AddController({
    super.key,
    required this.id,
    required this.quantity,
    required this.incrementOnPress,
    required this.decrementOnPress,
    required this.constraints,
    this.padding,
    this.borderRadius,
  });
  final int id;
  final int quantity;

  final Function() incrementOnPress;
  final Function() decrementOnPress;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  BorderRadius? borderRadius = const BorderRadius.all(
    Radius.circular(8),
  );

  @override
  State<AddController> createState() => _AddControllerState();
}

class _AddControllerState extends State<AddController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.buttonbgColor,
        borderRadius: widget.borderRadius,
        border: Border.all(
          color: AppColor.primaryColor,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      constraints: widget.constraints,
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.remove,
                color: AppColor.primaryColor,
                size: 18,
              ),
              onPressed: widget.decrementOnPress,
            ),
          ),
          Text(
            widget.quantity.toString(),
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
          Expanded(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.add,
                color: AppColor.primaryColor,
                size: 18,
              ),
              onPressed: widget.incrementOnPress,
            ),
          ),
        ],
      ),
    );
  }
}
