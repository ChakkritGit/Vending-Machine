// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/database/db_helper.dart';
import 'package:vending/src/models/drugs/drug_list_model.dart';
import 'package:vending/src/widgets/md_widget/popup_dialog.dart';

class DrugPriorityPopup extends StatefulWidget {
  final DrugGroup drug;
  final int qty;
  const DrugPriorityPopup({super.key, required this.drug, required this.qty});

  @override
  State<DrugPriorityPopup> createState() => _DrugPriorityPopupState();
}

class _DrugPriorityPopupState extends State<DrugPriorityPopup> {
  late TextEditingController userName;
  late TextEditingController userPassword;
  bool isHidden = false;

  @override
  void initState() {
    userName = TextEditingController();
    userPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    userPassword.dispose();
    super.dispose();
  }

  void showPass() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void verifyUser() async {
    if (userName.text.isNotEmpty && userPassword.text.isNotEmpty) {
      var result = await DatabaseHelper.instance.verifyUser(context,
          {'userName': userName.text, 'userPassword': userPassword.text});

      if (result == 'verify') {
        // Navigator.pop(context);
        Navigator.popUntil(
          context,
          ModalRoute.withName('/home'),
        );
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'ยาสำคัญ!',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
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
            Container(
              width: CustomInputStyle.inputWidthPopup,
              height: CustomInputStyle.inputHeightPopup,
              decoration: CustomInputStyle.buttonBoxdecoration,
              child: TextButton(
                onPressed: verifyUser,
                child: const Text(
                  'ดำเนินการต่อ',
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
