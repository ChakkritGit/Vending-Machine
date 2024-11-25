import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/drug/drug_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';
import 'package:vending_standalone/src/services/serialport.dart';
import 'package:vending_standalone/src/widgets/home_widget/medicine_bottom_sheet.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';

class MedicineList extends StatelessWidget {
  final Users user;
  final VendingMachine vending;
  const MedicineList({super.key, required this.user, required this.vending});

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
                                  horizontal: 6.0, vertical: 8.0),
                              child: Material(
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: !isOutOfStock
                                      ? () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            showDragHandle: true,
                                            useSafeArea: true,
                                            backgroundColor: Colors.white,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(30.0),
                                              ),
                                            ),
                                            builder: (context) {
                                              return FractionallySizedBox(
                                                widthFactor: 1.0,
                                                child: MedicineBottomSheet(
                                                  group: group,
                                                  user: user,
                                                  vending: vending,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      : null,
                                  splashColor: ColorsTheme.blackAlpha,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: isOutOfStock
                                          ? Colors.grey[300]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6.0,
                                          spreadRadius: 2.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    width: 180.0,
                                    height: 220.0,
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.file(
                                                File(group.drugImage),
                                                width: 100.0,
                                                height: 80.0,
                                                fit: BoxFit.contain,
                                                color: isOutOfStock
                                                    ? Colors.grey
                                                    : null,
                                                colorBlendMode:
                                                    BlendMode.saturation,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                  Icons.image,
                                                  size: 130.0,
                                                  color: ColorsTheme.grey,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  group.drugName,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: isOutOfStock
                                                        ? Colors.black38
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              CustomGap.smallHeightGap,
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 8.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    color: isOutOfStock
                                                        ? Colors.black45
                                                        : isLowQty
                                                            ? Colors.orange
                                                            : Colors.grey,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  totalQty != 0
                                                      ? 'คงเหลือ: $totalQty'
                                                      : 'สินค้าหมด',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: isOutOfStock
                                                        ? Colors.black45
                                                        : isLowQty
                                                            ? Colors.orange
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (group.drugPriority == 1)
                                          Positioned(
                                            right: 8.0,
                                            top: 8.0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: ColorsTheme.error,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Text(
                                                'สำคัญ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      );
                    },
                  ),
                ),
              );
            } else {
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
