import 'package:flutter/material.dart';
import 'package:vending/src/constants/colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          "ลืมรหัสผ่าน",
          style: TextStyle(
            color: ColorsTheme.primary,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
