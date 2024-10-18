import 'package:flutter/material.dart';
import 'package:vending/src/constants/colors.dart';

class ScaffoldMessage {
  static void show(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 24.0),
        ),
        backgroundColor: success ? ColorsTheme.sussess : ColorsTheme.error,
      ),
    );
  }
}
