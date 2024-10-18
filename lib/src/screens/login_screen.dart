import 'package:flutter/material.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/widgets/login_widget/body.dart';
import 'package:vending/src/widgets/login_widget/footer.dart';
import 'package:vending/src/widgets/login_widget/header.dart';

import 'package:vending/src/configs/routes.dart' as custom_route;

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
              child: Form(
                child: Column(
                  children: [
                    const LoginHeaderWidget(),
                    CustomGap.smallHeightGap,
                    const LoginBodyWidget(),
                    CustomGap.smallHeightGap,
                    const Footer(),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        custom_route.Routes.user,
                      ),
                      child: const Text('ทดสอบ'),
                    )
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
