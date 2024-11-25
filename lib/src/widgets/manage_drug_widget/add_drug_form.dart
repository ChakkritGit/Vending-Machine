import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/drugs/drug_model.dart';
import 'package:vending_standalone/src/widgets/md_widget/label_text.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';

class AddDrugForm extends StatefulWidget {
  final Drugs? drug;
  const AddDrugForm({super.key, this.drug});

  @override
  State<AddDrugForm> createState() => _AddDrugFormState();
}

class _AddDrugFormState extends State<AddDrugForm> {
  final ImagePicker _picker = ImagePicker();
  late int? selectedPriority = widget.drug?.drugPriority ?? 0;
  late TextEditingController drugName;
  late TextEditingController drugUnit;
  File? _imageFile;
  var uuid = const Uuid();

  Future<void> pickImage() async {
    if (_imageFile != null && _imageFile!.existsSync()) {
      await _imageFile!.delete();
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      final backupDir = Directory(join(appDocPath, 'images/drugs'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      String newFileName = 'img-${const Uuid().v4()}.jpg';
      String savedPath = join(backupDir.path, newFileName);

      final File imageFile = File(pickedFile.path);
      final File savedImage = await imageFile.copy(savedPath);

      setState(() {
        _imageFile = savedImage;
      });

      if (kDebugMode) {
        print('Saved image path: $savedPath');
      }
    }
  }

  Future handleSubmit(BuildContext context) async {
    String? imagePath = _imageFile?.path;

    if (imagePath != null &&
        drugName.text.isNotEmpty &&
        drugUnit.text.isNotEmpty) {
      var resulst = await DatabaseHelper.instance.createDrug(context, {
        'drugName': drugName.text,
        'drugUnit': drugUnit.text,
        'drugImage': imagePath,
        'drugPriority': selectedPriority,
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
    String? imagePath = _imageFile?.path;

    if (imagePath != null &&
        drugName.text.isNotEmpty &&
        drugUnit.text.isNotEmpty) {
      var result = await DatabaseHelper.instance.updateDrug(
          context,
          {
            'drugName': drugName.text,
            'drugUnit': drugUnit.text,
            'drugImage': imagePath,
            'drugPriority': selectedPriority,
            'updatedAt': DateTime.now().toIso8601String(),
          },
          widget.drug?.id);
      // ignore: use_build_context_synchronously
      if (result) Navigator.of(context).pop();
    } else {
      ScaffoldMessage.show(
          context, Icons.warning_amber_rounded, 'กรุณากรอกข้อมุลให้ครบ', 'w');
    }
  }

  @override
  void initState() {
    drugName = TextEditingController(text: widget.drug?.drugName);
    drugUnit = TextEditingController(text: widget.drug?.drugUnit);

    if (widget.drug != null) {
      _imageFile = File(widget.drug!.drugImage);
    }

    super.initState();
  }

  @override
  void dispose() {
    drugName.dispose();
    drugUnit.dispose();
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
            child: CustomLabel(text: 'ชื่อยา'),
          ),
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: drugName,
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
            child: CustomLabel(text: 'หน่วย'),
          ),
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: drugUnit,
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
            child: CustomLabel(text: 'ยาที่มีความสำคัญสูง'),
          ),
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        activeColor: ColorsTheme.primary,
                        focusColor: ColorsTheme.primary,
                        value: selectedPriority == 0,
                        onChanged: (bool? isChecked) {
                          setState(() {
                            selectedPriority = 0;
                          });
                        },
                      ),
                    ),
                    CustomGap.smallWidthGap,
                    const Text(
                      'ปกติ',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                CustomGap.mediumWidthGap,
                Row(
                  children: [
                    Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        activeColor: ColorsTheme.primary,
                        focusColor: ColorsTheme.primary,
                        value: selectedPriority == 1,
                        onChanged: (bool? isChecked) {
                          setState(() {
                            selectedPriority = 1;
                          });
                        },
                      ),
                    ),
                    CustomGap.smallWidthGap,
                    const Text(
                      'สำคัญ',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomGap.smallHeightGap,
          const Padding(
            padding: CustomPadding.paddingAll_10,
            child: CustomLabel(text: 'รูปภาพ'),
          ),
          GestureDetector(
            onTap: pickImage,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      16.0), // Adjust the radius as needed
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          width: 300.0,
                          height: 300.0,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.image,
                            size: 300.0,
                            color: ColorsTheme.grey,
                          ),
                        )
                      : Image.asset(
                          'lib/src/assets/images/user_placeholder.png',
                          width: 300.0,
                          height: 300.0,
                          fit: BoxFit.contain,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.5), // Semi-transparent background
                      borderRadius: const BorderRadius.only(
                        bottomLeft:
                            Radius.circular(16.0), // Match border radius
                        bottomRight:
                            Radius.circular(16.0), // Match border radius
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'เลือกรูปภาพ', // "Pick Image" in Thai
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomGap.mediumHeightGap,
          Container(
            width: CustomInputStyle.inputWidth,
            height: CustomInputStyle.inputHeight,
            decoration: CustomInputStyle.buttonBoxdecoration,
            child: TextButton(
              onPressed: () => widget.drug != null
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
