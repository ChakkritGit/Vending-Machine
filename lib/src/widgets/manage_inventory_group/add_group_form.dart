// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/drugs/drug_list_model.dart';
import 'package:vending_standalone/src/widgets/md_widget/label_text.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';

class AddGroupForm extends StatefulWidget {
  final List<Map<String, dynamic>> drugs;
  final List<Map<String, dynamic>> inventory;
  final DrugGroup? group;
  const AddGroupForm(
      {super.key, required this.drugs, required this.inventory, this.group});

  @override
  State<AddGroupForm> createState() => _AddGroupFormState();
}

class _AddGroupFormState extends State<AddGroupForm> {
  String? selectedDrugId;
  List<String> selectedInventoryIds = [];
  late TextEditingController groupMin;
  late TextEditingController groupMax;

  List<Map<String, dynamic>> createInventoryList() {
    List<Map<String, dynamic>> inventories = [];

    for (var inventoryId in selectedInventoryIds) {
      inventories.add({
        'inventoryId': inventoryId,
      });
    }

    return inventories;
  }

  Future handleSubmit(BuildContext context) async {
    if (!isSameFloor(selectedInventoryIds)) {
      ScaffoldMessage.show(context, Icons.warning_amber_rounded,
          'กรุณาจัดช่องในชั้นเดียวกัน', 'w');
      return;
    }

    if (selectedDrugId != null &&
        selectedInventoryIds.isNotEmpty &&
        groupMin.text.isNotEmpty &&
        groupMax.text.isNotEmpty) {
      var result = await DatabaseHelper.instance.createGroupAndInventory(
        context,
        drugId: selectedDrugId,
        inventories: createInventoryList(),
        groupMin: groupMin.text,
        groupMax: groupMax.text,
      );
      if (result) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมูลให้ครบ', 'w');
    }
  }

  Future handleSubmitEdit(BuildContext context) async {
    if (!isSameFloor(selectedInventoryIds)) {
      ScaffoldMessage.show(context, Icons.warning_amber_rounded,
          'กรุณาจัดช่องในชั้นเดียวกัน', 'w');
      return;
    }

    if (selectedDrugId != null &&
        selectedInventoryIds.isNotEmpty &&
        groupMin.text.isNotEmpty &&
        groupMax.text.isNotEmpty) {
      var result = await DatabaseHelper.instance.updateGroupAndInventory(
        context,
        widget.group?.groupId,
        drugId: selectedDrugId,
        inventories: createInventoryList(),
        groupMin: groupMin.text,
        groupMax: groupMax.text,
      );
      if (result) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมูลให้ครบ', 'w');
    }
  }

  bool isSameFloor(List<String> inventoryIds) {
    List<int> positions = inventoryIds
        .map((id) => widget.inventory.firstWhere(
            (inventory) => inventory['id'] == id)['inventoryPosition'] as int)
        .toList();

    int floor = (positions.first - 1) ~/ 10;

    return positions.every((position) => (position - 1) ~/ 10 == floor);
  }

  @override
  void initState() {
    groupMin = TextEditingController(text: widget.group?.groupMin.toString());
    groupMax = TextEditingController(text: widget.group?.groupMax.toString());
    if (widget.group != null) {
      selectedDrugId = widget.group?.drugId;
      for (var drugPos in widget.group!.inventoryList) {
        selectedInventoryIds.add(drugPos.inventoryId);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    groupMin.dispose();
    groupMax.dispose();
    super.dispose();
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
            child: CustomLabel(text: 'เลือกยา'),
          ),
          Container(
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              hint: const Text(
                'เลือกยา',
                style: TextStyle(fontSize: 20.0),
              ),
              value: selectedDrugId,
              items: [
                if (widget.group != null)
                  DropdownMenuItem<String>(
                    value: widget.group!.drugId,
                    child: Text(
                      widget.group!.drugName,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ),
                ...widget.drugs
                    .where((drug) => drug['id'] != widget.group?.drugId)
                    .map((drug) {
                  return DropdownMenuItem<String>(
                    value: drug['id'],
                    child: Text(
                      drug['drugName'],
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDrugId = value;
                  });
                }
              },
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
          CustomGap.smallHeightGap,
          const Padding(
            padding: CustomPadding.paddingAll_10,
            child: CustomLabel(text: 'เลือกช่อง'),
          ),
          Container(
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: MultiSelectDialogField(
              initialValue: selectedInventoryIds,
              backgroundColor: Colors.white,
              dialogHeight: 700.0,
              items: [
                if (widget.group != null)
                  ...widget.group!.inventoryList.map((inventory) {
                    return MultiSelectItem<String>(
                      inventory.inventoryId,
                      'ช่องที่ ${inventory.inventoryPosition}',
                    );
                  }),
                ...widget.inventory
                    .where((inventory) =>
                        !selectedInventoryIds.contains(inventory['id']))
                    .map((inventory) {
                  return MultiSelectItem<String>(
                    inventory['id'],
                    'ช่องที่ ${inventory['inventoryPosition']}',
                  );
                }),
              ],
              title: const Text("เลือกช่อง"),
              selectedColor: ColorsTheme.primary,
              decoration: const BoxDecoration(
                border: null,
              ),
              buttonIcon: const Icon(
                Icons.arrow_drop_down,
              ),
              buttonText: const Text(
                "เลือกช่อง",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                selectedInventoryIds = List<String>.from([...results]);
              },
              cancelText: const Text(
                'ยกเลิก',
                style: TextStyle(fontSize: 20.0, color: Colors.red),
              ),
              confirmText: const Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          CustomGap.smallHeightGap,
          const Padding(
            padding: CustomPadding.paddingAll_10,
            child: CustomLabel(text: 'Min'),
          ),
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: groupMin,
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
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: groupMax,
              style: CustomInputStyle.inputStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: CustomInputStyle.inputHintStyle,
              ),
            ),
          ),
          CustomGap.mediumHeightGap,
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            decoration: CustomInputStyle.buttonBoxdecoration,
            child: TextButton(
              onPressed: () => widget.group != null
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
