import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/initail_store.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';
import 'package:vending_standalone/src/widgets/login_widget/login_button.dart';

class LoginBodyWidget extends StatefulWidget {
  const LoginBodyWidget({super.key});

  @override
  State<LoginBodyWidget> createState() => _LoginBodyWidgetState();
}

class _LoginBodyWidgetState extends State<LoginBodyWidget> {
  late TextEditingController userName;
  late TextEditingController userPassword;
  bool isHidden = false;
  bool isLoading = false;

  void login() async {
    if (userName.text.isEmpty || userPassword.text.isEmpty) {
      ScaffoldMessage.show(context, Icons.warning_amber_rounded,
          'กรุณาป้อนชื่อผู้ใช้และรหัสผ่าน', 'w');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final result = await DatabaseHelper.instance.checkLogin(
        context,
        {'userName': userName.text, 'userPassword': userPassword.text},
      );

      if (result.isNotEmpty) {
        StoredLocal storage = StoredLocal.instance;
        await storage.saveUserData('userData', result);

        await DatabaseHelper.instance.loginLog({
          'userId': result[0]['id'],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamedAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          custom_route.Routes.home,
          (route) => false,
        );
        userName.clear();
        userPassword.clear();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print(error);
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
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
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            decoration: isLoading
                ? CustomInputStyle.buttonBoxdecorationDisable
                : CustomInputStyle.buttonBoxdecoration,
            child: LoginButton(
              isLoading: isLoading,
              onPressed: login,
            ),
          )
        ],
      ),
    );
  }
}
