import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "lib/src/assets/images/login_banner.gif",
            width: 250.0,
            fit: BoxFit.cover,
          ),
          const Text(
            "Ward Stock Dispensing Machine",
            style: CustomInputStyle.headerTitle,
          ),
          CustomGap.mediumHeightGap,
          const Text(
            "Automated medicine dispensing machine",
            style: CustomInputStyle.headerDescription,
          )
        ],
      ),
    );
  }
}
