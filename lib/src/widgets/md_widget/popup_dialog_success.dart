// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/dispense/dispense_order_model.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';

class PopupDialogSuccess extends StatefulWidget {
  final IconData icon;
  final String title;
  final String content;
  final String textButton;
  final Users user;
  final Dispense order;
  final List<Map<String, dynamic>> itemsToUpdate;

  const PopupDialogSuccess({
    super.key,
    required this.itemsToUpdate,
    required this.icon,
    required this.content,
    required this.textButton,
    required this.title,
    required this.user,
    required this.order,
  });

  @override
  State<PopupDialogSuccess> createState() => _PopupDialogSuccessState();
}

class _PopupDialogSuccessState extends State<PopupDialogSuccess>
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

  Future<void> updateStockInDatabase(BuildContext context) async {
    try {
      await DatabaseHelper.instance
          .updateStockOrder(context, widget.itemsToUpdate);
      await DatabaseHelper.instance.addOrder(widget.order, widget.user);
    } catch (error) {
      if (kDebugMode) {
        print("เกิดข้อผิดพลาดในการอัปเดตสต็อก: $error");
      }
    }
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
              color: Colors.green,
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
            onPressed: () async {
              await updateStockInDatabase(context);
              // Navigator.pop(context);
              Navigator.popUntil(
                context,
                ModalRoute.withName('/home'),
              );
            },
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
