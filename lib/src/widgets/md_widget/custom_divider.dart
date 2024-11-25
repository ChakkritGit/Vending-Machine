import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  const CustomDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: ColorsTheme.grey,
            margin: const EdgeInsets.only(right: 10),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            color: ColorsTheme.grey,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: ColorsTheme.grey,
            margin: const EdgeInsets.only(left: 10),
          ),
        ),
      ],
    );
  }
}
