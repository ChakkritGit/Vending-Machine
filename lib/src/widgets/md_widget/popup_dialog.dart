import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';

class PopupDialog extends StatefulWidget {
  final bool isError;
  final IconData icon;
  final String title;
  final String content;
  final String textButton;

  const PopupDialog({
    super.key,
    required this.isError,
    required this.icon,
    required this.content,
    required this.textButton,
    required this.title,
  });

  @override
  State<PopupDialog> createState() => _PopupDialogState();
}

class _PopupDialogState extends State<PopupDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              widget.icon,
              size: 28.0,
              color: widget.isError ? Colors.red : Colors.amber,
            ),
            CustomGap.smallWidthGap_1,
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          widget.content,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              widget.textButton,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
