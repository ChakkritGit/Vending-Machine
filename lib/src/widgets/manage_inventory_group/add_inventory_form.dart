// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/inventory/inventory.dart';
import 'package:vending_standalone/src/widgets/md_widget/label_text.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';

class AddInventoryForm extends StatefulWidget {
  final List<Map<String, dynamic>> availablePositions;
  final List<Map<String, dynamic>> machines;
  final Inventories? inventory;
  const AddInventoryForm(
      {super.key,
      required this.machines,
      required this.availablePositions,
      this.inventory});

  @override
  State<AddInventoryForm> createState() => _AddInventoryFormState();
}

class _AddInventoryFormState extends State<AddInventoryForm> {
  int? selectedPosition;
  String? selectedMachineId;

  // late TextEditingController inventoryQty;
  late TextEditingController inventoryMin;
  late TextEditingController inventoryMAX;

  Future handleSubmit(BuildContext context) async {
    if (selectedPosition != null &&
        selectedMachineId != null &&
        // inventoryQty.text.isNotEmpty &&
        inventoryMin.text.isNotEmpty &&
        inventoryMAX.text.isNotEmpty) {
      var resulst = await DatabaseHelper.instance.createInventory(context, {
        'inventoryPosition': selectedPosition,
        'inventoryQty': 0,
        'inventoryMin': inventoryMin.text,
        'inventoryMAX': inventoryMAX.text,
        'machineId': selectedMachineId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      if (resulst) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมุลให้ครบ', 'w');
    }
  }

  Future handleSubmitEdit(BuildContext context) async {
    if (inventoryMin.text.isNotEmpty && inventoryMAX.text.isNotEmpty) {
      var resulst = await DatabaseHelper.instance.updateInventory(
          context,
          {
            'inventoryMin': inventoryMin.text,
            'inventoryMAX': inventoryMAX.text,
            'updatedAt': DateTime.now().toIso8601String(),
          },
          widget.inventory?.id);
      if (resulst) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมุลให้ครบ', 'w');
    }
  }

  @override
  void initState() {
    // inventoryQty = TextEditingController();
    inventoryMin =
        TextEditingController(text: widget.inventory?.inventoryMin.toString());
    inventoryMAX =
        TextEditingController(text: widget.inventory?.inventoryMAX.toString());
    super.initState();
  }

  @override
  void dispose() {
    // inventoryQty.dispose();
    inventoryMin.dispose();
    inventoryMAX.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.inventory != null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: CustomPadding.paddingAll_10,
                      child: CustomLabel(text: 'ตำแหน่ง'),
                    ),
                    Container(
                      height: CustomInputStyle.inputHeight,
                      margin: CustomMargin.marginSymmetricVertical_1,
                      padding: CustomPadding.paddingSymmetricInput,
                      decoration: CustomInputStyle.inputBoxdecoration,
                      child: DropdownButton<int>(
                        dropdownColor: Colors.white,
                        value: selectedPosition,
                        hint: const Text(
                          'เลือกตำแหน่ง',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        items: widget.availablePositions.map((position) {
                          return DropdownMenuItem<int>(
                            value: position['value'],
                            child: Text(
                              position['label'],
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPosition = value;
                          });
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                    CustomGap.smallHeightGap,
                  ],
                ),
          // CustomGap.smallHeightGap,
          // const Padding(
          //   padding: CustomPadding.paddingAll_10,
          //   child: CustomLabel(text: 'จำนวน'),
          // ),
          // Container(
          //   height: CustomInputStyle.inputHeight,
          //   margin: CustomMargin.marginSymmetricVertical_1,
          //   padding: CustomPadding.paddingSymmetricInput,
          //   decoration: CustomInputStyle.inputBoxdecoration,
          //   child: TextFormField(
          //     controller: inventoryQty,
          //     keyboardType: TextInputType.number,
          //     style: CustomInputStyle.inputStyle,
          //     decoration: const InputDecoration(
          //       border: InputBorder.none,
          //       hintStyle: CustomInputStyle.inputHintStyle,
          //     ),
          //   ),
          // ),
          const Padding(
            padding: CustomPadding.paddingAll_10,
            child: CustomLabel(text: 'Min'),
          ),
          Container(
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: inventoryMin,
              keyboardType: TextInputType.number,
              style: CustomInputStyle.inputStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: CustomInputStyle.inputHintStyle,
              ),
            ),
          ),
          CustomGap.smallHeightGap,
          const Padding(
            padding: CustomPadding.paddingAll_10,
            child: CustomLabel(text: 'Max'),
          ),
          Container(
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: inventoryMAX,
              keyboardType: TextInputType.number,
              style: CustomInputStyle.inputStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: CustomInputStyle.inputHintStyle,
              ),
            ),
          ),
          widget.inventory != null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomGap.smallHeightGap,
                    const Padding(
                      padding: CustomPadding.paddingAll_10,
                      child: CustomLabel(text: 'เลือกเครื่อง'),
                    ),
                    Container(
                      height: CustomInputStyle.inputHeight,
                      margin: CustomMargin.marginSymmetricVertical_1,
                      padding: CustomPadding.paddingSymmetricInput,
                      decoration: CustomInputStyle.inputBoxdecoration,
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        hint: const Text(
                          'เลือกเครื่อง',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        value: selectedMachineId,
                        items: widget.machines.map((machine) {
                          return DropdownMenuItem<String>(
                            value: machine['id'],
                            child: Text(
                              machine['machineName'],
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMachineId = value;
                          });
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  ],
                ),
          CustomGap.mediumHeightGap,
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            decoration: CustomInputStyle.buttonBoxdecoration,
            child: TextButton(
              onPressed: () => widget.inventory != null
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
