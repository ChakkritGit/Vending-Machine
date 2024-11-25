import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/stocks/stocks.dart';
import 'package:vending_standalone/src/widgets/md_widget/label_text.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';

class AddStockForm extends StatefulWidget {
  final Stocks? stock;
  const AddStockForm({super.key, this.stock});

  @override
  State<AddStockForm> createState() => _AddStockFormState();
}

class _AddStockFormState extends State<AddStockForm> {
  late TextEditingController inventoryQty;
  late int currentQty;

  @override
  void initState() {
    currentQty = widget.stock?.qty ?? 0;
    inventoryQty = TextEditingController(text: currentQty.toString());
    super.initState();
  }

  @override
  void dispose() {
    inventoryQty.dispose();
    super.dispose();
  }

  void increaseQty() {
    if (currentQty < widget.stock!.maxQty) {
      setState(() {
        currentQty++;
        inventoryQty.text = currentQty.toString();
      });
    }
  }

  void decreaseQty() {
    if (currentQty > 0) {
      setState(() {
        currentQty--;
        inventoryQty.text = currentQty.toString();
      });
    }
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
        ScaffoldMessage.show(context, Icons.warning_amber_rounded,
            'จำนวนที่กรอกมากกว่าจำนวนที่ใส่ได้สูงสุด', 'w');
      }
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
            child: CustomLabel(text: 'จำนวน'),
          ),
          CustomGap.mediumHeightGap,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.remove),
                  onPressed: currentQty > 0 ? decreaseQty : null,
                ),
              ),
              CustomGap.mediumWidthGap,
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: inventoryQty,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              CustomGap.mediumWidthGap,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.add),
                  onPressed:
                      currentQty < widget.stock!.maxQty ? increaseQty : null,
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
              onPressed: () => handleSubmit(context),
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
