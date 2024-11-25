import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';

class FloatingButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final String route;
  const FloatingButton(
      {super.key, required this.text, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(170.0, 80.0),
      child: FloatingActionButton.extended(
        splashColor: ColorsTheme.primary,
        backgroundColor: ColorsTheme.primary,
        onPressed: () => Navigator.pushNamed(
          // ignore: use_build_context_synchronously
          context,
          route,
        ),
        label: Text(
          text,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        icon: Icon(
          icon,
          size: 32.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
