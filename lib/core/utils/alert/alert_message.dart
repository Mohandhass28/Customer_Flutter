import 'package:flutter/material.dart';

class AlertMessage {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required Function() onOkPressed,
    required Function() onCancelPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();
                // Then execute the callback
                onCancelPressed();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();
                // Then execute the callback
                onOkPressed();
              },
            ),
          ],
        );
      },
    );
  }
}
