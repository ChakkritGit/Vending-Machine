import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/drugs/drug_model.dart';
import 'package:vending_standalone/src/widgets/manage_drug_widget/add_drug_form.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class AddDrugScreen extends StatefulWidget {
  final String? titleText;
  final Drugs? drug;
  const AddDrugScreen({super.key, this.titleText, this.drug});

  @override
  State<AddDrugScreen> createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends State<AddDrugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.titleText ?? 'เพิ่มยา',
        isBottom: false,
      ),
      body: Container(
          color: Colors.white,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            padding: CustomPadding.paddingAll_15,
            child: Form(
              child: AddDrugForm(
                drug: widget.drug,
              ),
            ),
          )),
    );
  }
}
