import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';
import 'package:vending_standalone/src/widgets/manage_user_widget/add_user_form.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class AddUserScreen extends StatefulWidget {
  final String? titleText;
  final Users? user;
  const AddUserScreen({super.key, this.titleText, this.user});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.titleText ?? 'เพิ่มผู้ใช้',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: CustomPadding.paddingAll_15,
          child: Form(
            child: AddUserForm(
              user: widget.user,
            ),
          ),
        ),
      ),
    );
  }
}
