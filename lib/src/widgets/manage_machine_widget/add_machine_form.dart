import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/security_questions.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/machine/machine_model.dart';
import 'package:vending_standalone/src/widgets/md_widget/label_text.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';

class AddMachineForm extends StatefulWidget {
  final Machines? machine;
  const AddMachineForm({super.key, this.machine});

  @override
  State<AddMachineForm> createState() => _AddMachineFormState();
}

class _AddMachineFormState extends State<AddMachineForm> {
  late TextEditingController machineName;
  int? selectedStatus = 0;

  @override
  void initState() {
    machineName = TextEditingController(text: widget.machine?.machineName);

    if (widget.machine != null) {
      selectedStatus = widget.machine?.machineStatus;
    }
    super.initState();
  }

  @override
  void dispose() {
    machineName.dispose();
    super.dispose();
  }

  Future handleSubmit(BuildContext context) async {
    if (machineName.text.isNotEmpty && selectedStatus != null) {
      var resulst = await DatabaseHelper.instance.createMachine(context, {
        'machineName': machineName.text,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      // ignore: use_build_context_synchronously
      if (resulst) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมุลให้ครบ', 'w');
    }
  }

  Future handleSubmitEdit(BuildContext context) async {
    if (machineName.text.isNotEmpty) {
      var result = await DatabaseHelper.instance.updateMachine(
          context,
          {
            'machineName': machineName.text,
            'machineStatus': selectedStatus,
            'updatedAt': DateTime.now().toIso8601String()
          },
          widget.machine?.id);
      // ignore: use_build_context_synchronously
      if (result) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมุลให้ครบ', 'w');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: CustomPadding.paddingAll_10,
            child: CustomLabel(text: 'ชื่อเครื่อง'),
          ),
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: machineName,
              style: CustomInputStyle.inputStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: CustomInputStyle.inputHintStyle,
              ),
            ),
          ),
          widget.machine != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomGap.smallHeightGap,
                    const Padding(
                      padding: CustomPadding.paddingAll_10,
                      child: CustomLabel(text: 'สถานะการใช้งาน'),
                    ),
                    Container(
                      height: CustomInputStyle.inputHeight,
                      margin: CustomMargin.marginSymmetricVertical_1,
                      padding: CustomPadding.paddingSymmetricInput,
                      decoration: CustomInputStyle.inputBoxdecoration,
                      child: DropdownButton<int>(
                        dropdownColor: Colors.white,
                        value: selectedStatus,
                        hint: const Text('เลือกสถานะ'),
                        items: SecurityUserStatus.status.map((question) {
                          return DropdownMenuItem<int>(
                            value: question['value'],
                            child: Text(
                              question['label'],
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    )
                  ],
                )
              : Container(),
          CustomGap.mediumHeightGap,
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            decoration: CustomInputStyle.buttonBoxdecoration,
            child: TextButton(
              onPressed: () => widget.machine != null
                  ? handleSubmitEdit(context)
                  : handleSubmit(context),
              child: const Text(
                "บันทึก",
                style: CustomInputStyle.textButtonStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
