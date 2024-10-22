// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/database/db_helper.dart';
import 'package:vending/src/models/drugs/drug_list_model.dart';

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
  String error = '';

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
        setState(() {
          error = '';
        });
        Navigator.pop(context);
      } else {
        setState(() {
          error = result;
        });
      }
    } else {
      setState(() {
        error = '*** กรุณาป้อนข้อมูลให้ครบ ***';
      });
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
          'ยาสำคัญจำเป็นต้องมีการยืนยันจากเจ้าหน้าที่อย่างต่ำหนึ่งคน',
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
        CustomGap.smallHeightGap,
        error != ''
            ? Center(
                child: Text(
                  error,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: ColorsTheme.error,
                  ),
                ),
              )
            : Container(),
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
