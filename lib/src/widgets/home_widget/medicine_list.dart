import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending/src/blocs/drug/drug_bloc.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/widgets/utils/no_data.dart';

class MedicineList extends StatelessWidget {
  const MedicineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 25.0,
        left: 10.0,
        right: 10.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: BlocBuilder<DrugBloc, DrugState>(
          builder: (context, state) {
            if (state.drugInventoryList.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    (state.drugInventoryList.length / 10).ceil(),
                    (rowIndex) {
                      int startIndex = rowIndex * 10;
                      int endIndex = (startIndex + 10)
                          .clamp(0, state.drugInventoryList.length);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            List.generate(endIndex - startIndex, (cardIndex) {
                          if (startIndex + cardIndex <
                              state.drugInventoryList.length) {
                            var group =
                                state.drugInventoryList[startIndex + cardIndex];
                            int totalQty = group.inventoryList.fold(
                                0, (sum, item) => sum + item.inventoryQty!);

                            bool isLowQty = totalQty <=
                                int.parse(group.groupMin.toString());
                            bool isOutOfStock = totalQty == 0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3.0, vertical: 3.0),
                              child: SizedBox(
                                width: 240.0,
                                height: 285.0,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.file(
                                        File(group.drugImage),
                                        width: 180.0,
                                        height: 130.0,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.image,
                                          size: 130.0,
                                          color: ColorsTheme.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          group.drugName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 8.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: isOutOfStock
                                                ? Colors.red
                                                : isLowQty
                                                    ? Colors.orange
                                                    : Colors
                                                        .grey, // กรอบเปลี่ยนสี
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Text(
                                          'คงเหลือ: $totalQty',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: isOutOfStock
                                                ? Colors.red // แสดงสีแดงถ้าหมด
                                                : isLowQty
                                                    ? Colors
                                                        .orange // แสดงสีส้มถ้าต่ำกว่า minQty
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox
                                .shrink(); // ถ้าไม่มีการ์ดให้แสดง ข้ามไป
                          }
                        }),
                      );
                    },
                  ),
                ),
              );
            } else {
              // ใช้ SizedBox.expand หรือ Container ที่มีขนาดเต็มจอแทน Expanded
              return const SizedBox.expand(
                child: Center(
                  child: NoData(
                    icon: Icons.category,
                    text: 'ไม่พบรายการ',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
