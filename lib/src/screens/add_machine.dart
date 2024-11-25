import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/machine/machine_model.dart';
import 'package:vending_standalone/src/widgets/manage_machine_widget/add_machine_form.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class AddMachineScreen extends StatefulWidget {
  final String? titleText;
  final Machines? machine;
  const AddMachineScreen({super.key, this.machine, this.titleText});

  @override
  State<AddMachineScreen> createState() => _AddMachineScreenState();
}

class _AddMachineScreenState extends State<AddMachineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.titleText ?? 'เพิ่มเครื่อง',
        isBottom: false,
      ),
      body: Container(
          color: Colors.white,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            padding: CustomPadding.paddingAll_15,
            child: Form(
              child: AddMachineForm(
                machine: widget.machine,
              ),
            ),
          )),
    );
  }
}
