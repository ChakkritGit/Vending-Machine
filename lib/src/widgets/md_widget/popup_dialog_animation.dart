import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';

class PopupDialogAnimation extends StatefulWidget {
  const PopupDialogAnimation(
      {super.key});

  @override
  State<PopupDialogAnimation> createState() => _PopupDialogAnimationState();
}

class _PopupDialogAnimationState extends State<PopupDialogAnimation>
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
        content: SizedBox(
          width: 450.0,
          height: 450.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/src/assets/images/dispense_banner.gif',
                fit: BoxFit.contain,
                width: double.infinity,
                height: 300.0,
              ),
              CustomGap.smallHeightGap,
              const Text(
                'กำลังจัดยา',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
