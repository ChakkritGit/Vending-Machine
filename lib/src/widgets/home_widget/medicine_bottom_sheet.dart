import 'package:flutter/material.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/models/drugs/drug_list_model.dart';
import 'package:vending/src/widgets/home_widget/popup_dialog.dart';
import 'package:vending/src/widgets/md_widget/popup_dialog.dart';

class MedicineBottomSheet extends StatefulWidget {
  final DrugGroup group;
  const MedicineBottomSheet({super.key, required this.group});

  @override
  State<MedicineBottomSheet> createState() => _MedicineBottomSheetState();
}

class _MedicineBottomSheetState extends State<MedicineBottomSheet> {
  late TextEditingController addQty;
  late int currentQty = 0;
  late int maxQty = widget.group.inventoryList
      .fold(0, (sum, item) => sum + item.inventoryQty!);

  void increaseQty() {
    if (currentQty < maxQty) {
      setState(() {
        currentQty++;
        addQty.text = currentQty.toString();
      });
    }
  }

  void decreaseQty() {
    if (currentQty > 0) {
      setState(() {
        currentQty--;
        addQty.text = currentQty.toString();
      });
    }
  }

  void checkDrugPriority(int qty, DrugGroup drug) {
    if (drug.drugPriority == 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => DrugPriorityPopup(
          drug: drug,
          qty: qty,
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    addQty = TextEditingController(text: currentQty.toString());
    super.initState();
  }

  @override
  void dispose() {
    addQty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.group.drugName,
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomGap.smallWidthGap_1,
                  widget.group.drugPriority == 1
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          child: const Text(
                            'ยาสำคัญ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Text(
                widget.group.drugUnit,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              )
            ],
          )),
          CustomGap.mediumHeightGap,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: addQty,
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.add),
                  onPressed: currentQty < maxQty ? increaseQty : null,
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
              onPressed: () {
                if (currentQty > 0) {
                  checkDrugPriority(currentQty, widget.group);
                } else {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const PopupDialog(
                      isError: false,
                      icon: Icons.warning_rounded,
                      title: 'คำเตือน',
                      content: 'กรุณาเลือกจำนวน',
                      textButton: 'ตกลง',
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 32.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
