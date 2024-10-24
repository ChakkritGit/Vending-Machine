import 'package:flutter/material.dart';
import 'package:vending/src/constants/style.dart';

class PopupDialog extends StatelessWidget {
  final bool isError;
  final IconData icon;
  final String title;
  final String content;
  final String textButton;
  const PopupDialog(
      {super.key,
      required this.isError,
      required this.icon,
      required this.content,
      required this.textButton,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            icon,
            size: 28.0,
            color: isError ? Colors.red : Colors.amber,
          ),
          CustomGap.smallWidthGap_1,
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              textButton,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ))
      ],
    );
  }
}
