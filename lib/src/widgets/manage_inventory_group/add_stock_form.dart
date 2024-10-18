import 'package:flutter/material.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/database/db_helper.dart';
import 'package:vending/src/models/stocks/stocks.dart';
import 'package:vending/src/widgets/md_widget/label_text.dart';
import 'package:vending/src/widgets/utils/scaffold_message.dart';

class AddStockForm extends StatefulWidget {
  final Stocks? stock;
  const AddStockForm({super.key, this.stock});

  @override
  State<AddStockForm> createState() => _AddStockFormState();
}

class _AddStockFormState extends State<AddStockForm> {
  late TextEditingController inventoryQty;

  @override
  void initState() {
    inventoryQty = TextEditingController(text: widget.stock?.qty.toString());
    super.initState();
  }

  @override
  void dispose() {
    inventoryQty.dispose();
    super.dispose();
  }

  Future handleSubmit(BuildContext context) async {
    if (inventoryQty.text.isNotEmpty) {
      int qty = int.parse(inventoryQty.text);
      if (qty <= widget.stock!.maxQty) {
        var result = await DatabaseHelper.instance.updateStock(
            context,
            {
              'inventoryQty': inventoryQty.text,
              'updatedAt': DateTime.now().toIso8601String(),
            },
            widget.stock?.id);
        // ignore: use_build_context_synchronously
        if (result) Navigator.of(context).pop();
      } else {
        ScaffoldMessage.show(
            context, 'จำนวนที่กรอกมากกว่าจำนวนที่ใส่ได้สูงสุด', false);
      }
    } else {
      ScaffoldMessage.show(context, 'กรุณากรอกข้อมุลให้ครบ', false);
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
            child: CustomLabel(text: 'จำนวน'),
          ),
          Container(
            height: CustomInputStyle.inputHeight,
            margin: CustomMargin.marginSymmetricVertical_1,
            padding: CustomPadding.paddingSymmetricInput,
            decoration: CustomInputStyle.inputBoxdecoration,
            child: TextFormField(
              controller: inventoryQty,
              keyboardType: TextInputType.number,
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
              onPressed: () => handleSubmit(context),
              child: const Text(
                "บันทึก",
                style: CustomInputStyle.textButtonStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
