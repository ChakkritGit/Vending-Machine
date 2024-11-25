import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';

class NoData extends StatelessWidget {
  final IconData icon;
  final String text;
  const NoData({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 52.0,
            color: ColorsTheme.grey,
          ),
          CustomGap.smallHeightGap,
          Text(
            text,
            style: const TextStyle(
              fontSize: 32.0,
              color: ColorsTheme.grey,
            ),
          ),
        ],
      ),
    );
  }
}
