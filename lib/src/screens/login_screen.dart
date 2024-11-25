import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/widgets/login_widget/body.dart';
import 'package:vending_standalone/src/widgets/login_widget/footer.dart';
import 'package:vending_standalone/src/widgets/login_widget/header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ColorsTheme.primaryAlpha,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.145,
                  vertical: 15.0),
              child: const Form(
                child: Column(
                  children: [
                    LoginHeaderWidget(),
                    CustomGap.smallHeightGap,
                    LoginBodyWidget(),
                    CustomGap.smallHeightGap,
                    Footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
