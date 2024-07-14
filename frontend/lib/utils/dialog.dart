import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showWarnDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  required String title,
  required String content,
  required String confirmText,
  required String cancelText,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            style: TextButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            label: Text(confirmText),
          ),
          TextButton.icon(
            icon: const Icon(Icons.cancel),
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text(cancelText),
          ),
        ],
      );
    },
  );
}
