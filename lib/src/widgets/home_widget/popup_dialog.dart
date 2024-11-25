// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/dispense/dispense_order_model.dart';
import 'package:vending_standalone/src/models/drugs/drug_list_model.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';
import 'package:vending_standalone/src/services/dispense_order.dart';
import 'package:vending_standalone/src/services/serialport.dart';
import 'package:vending_standalone/src/widgets/md_widget/popup_dialog.dart';
import 'package:vending_standalone/src/widgets/md_widget/popup_dialog_animation.dart';
import 'package:vending_standalone/src/widgets/md_widget/popup_dialog_success.dart';

class DrugPriorityPopup extends StatefulWidget {
  final DrugGroup drug;
  final int qty;
  final Users user;
  final VendingMachine vending;
  const DrugPriorityPopup({
    super.key,
    required this.drug,
    required this.qty,
    required this.user,
    required this.vending,
  });

  @override
  State<DrugPriorityPopup> createState() => _DrugPriorityPopupState();
}

class _DrugPriorityPopupState extends State<DrugPriorityPopup>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> itemsToUpdate = [];

  late TextEditingController userName;
  late TextEditingController userPassword;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late DispenseOrder dispense = DispenseOrder(vending: widget.vending);
  bool isHidden = false;

  void showPass() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void verifyUser(String storeUserName) async {
    if (userName.text.isNotEmpty && userPassword.text.isNotEmpty) {
      var result = await DatabaseHelper.instance.verifyUser(
          context,
          {'userName': userName.text, 'userPassword': userPassword.text},
          storeUserName);

      if (result == 'verify') {
        // สั่งเครื่องหยิบ
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const PopupDialogAnimation(),
        );

        var complete = await processOrder(widget.qty, widget.drug);

        if (complete) {
          navigateToHome(Dispense(qty: widget.qty, drug: widget.drug));
        }
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => PopupDialog(
            isError: true,
            icon: Icons.error_rounded,
            title: 'ผิดพลาด',
            content: result,
            textButton: 'ลองอีกครั้ง',
          ),
        );
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const PopupDialog(
          isError: false,
          icon: Icons.warning_rounded,
          title: 'คำเตือน',
          content: 'กรุณาป้อนข้อมูลให้ครบ',
          textButton: 'ลองอีกครั้ง',
        ),
      );
    }
  }

  Future<bool> processOrder(int qty, DrugGroup drug) async {
    int totalQty = qty;
    itemsToUpdate = [];

    for (var inventory in drug.inventoryList) {
      if (totalQty <= 0) break;

      int inventoryQty = inventory.inventoryQty ?? 0;
      int inventoryPosition = inventory.inventoryPosition ?? 0;
      int qtyToDeduct = 0;

      if (totalQty > 0) {
        if (totalQty > inventoryQty) {
          qtyToDeduct = inventoryQty;
          totalQty -= qtyToDeduct;
          inventory.inventoryQty = 0;
        } else {
          qtyToDeduct = totalQty;
          inventory.inventoryQty = inventoryQty - qtyToDeduct;
          totalQty = 0;
        }

        if (qtyToDeduct > 0) {
          var success =
              await dispense.sendToMachine(qtyToDeduct, inventoryPosition, qty);
          if (!success) return false;

          itemsToUpdate.add({
            'inventoryId': inventory.inventoryId,
            'quantity': qtyToDeduct,
          });
        }
      }
    }
    return totalQty <= 0;
  }

  void navigateToHome(Dispense order) {
    // Navigator.popUntil(
    //   context,
    //   ModalRoute.withName('/home'),
    // );
    Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopupDialogSuccess(
        itemsToUpdate: itemsToUpdate,
        icon: Icons.check_circle_outline_rounded,
        content: 'กรุณารับยาที่ช่องรับยาด้านล่าง',
        textButton: 'ตกลง',
        title: 'จัดยาสำเร็จ',
        user: widget.user,
        order: order,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userName = TextEditingController();
    userPassword = TextEditingController();
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
    dispense.dispose();
    userName.dispose();
    userPassword.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Column(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 52.0,
                color: Colors.amber,
              ),
              CustomGap.smallHeightGap,
              Text(
                'ยาสำคัญ',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        content: const Center(
          heightFactor: 1.0,
          child: Text(
            'ยาสำคัญจำเป็นต้องมีการยืนยันจากเจ้าหน้าที่ ๆมีสิทธิอย่างน้อยหนึ่งคน',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        actions: [
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              style: CustomInputStyle.inputStyle,
              controller: userName,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                iconColor: ColorsTheme.grey,
                border: InputBorder.none,
                hintText: "ชื่อผู้ใช้",
                hintStyle: CustomInputStyle.inputHintStyle,
              ),
            ),
          ),
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              style: CustomInputStyle.inputStyle,
              controller: userPassword,
              obscureText: !isHidden,
              decoration: InputDecoration(
                icon: const Icon(Icons.lock),
                iconColor: ColorsTheme.grey,
                border: InputBorder.none,
                hintText: "รหัสผ่าน",
                hintStyle: CustomInputStyle.inputHintStyle,
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  color: ColorsTheme.grey,
                  onPressed: showPass,
                  icon: Icon(
                    !isHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
          ),
          CustomGap.mediumHeightGap,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: CustomInputStyle.inputWidthPopup,
                height: CustomInputStyle.inputHeightPopup,
                decoration: CustomInputStyle.buttonBoxdecorationCancel,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomGap.smallWidthGap_1,
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state.userData.isNotEmpty) {
                    final user = state.userData[0];
                    return Container(
                      width: CustomInputStyle.inputWidthPopup,
                      height: CustomInputStyle.inputHeightPopup,
                      decoration: CustomInputStyle.buttonBoxdecoration,
                      child: TextButton(
                        onPressed: () => verifyUser(user.userName),
                        child: const Text(
                          'ดำเนินการต่อ',
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
