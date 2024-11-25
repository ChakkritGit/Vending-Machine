import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:
          isLoading ? null : onPressed, // Disable button when isLoading is true
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "ล็อกอิน",
              style: CustomInputStyle.textButtonStyle,
            ),
    );
  }
}
