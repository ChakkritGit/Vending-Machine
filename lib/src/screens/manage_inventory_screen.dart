// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/inventory/inventory_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/inventory/inventory.dart';
import 'package:vending_standalone/src/screens/add_inventory.dart';
import 'package:vending_standalone/src/widgets/md_widget/floating_button.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';
import 'package:vending_standalone/src/widgets/utils/search_widget.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;

class ManageInventoryScreen extends StatefulWidget {
  const ManageInventoryScreen({super.key});

  @override
  State<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> {
  late TextEditingController searchController;
  List<Inventories> filteredInventory = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text;
    final inventoryList = context.read<InventoryBloc>().state.inventoryList;

    setState(() {
      filteredInventory = inventoryList.where((inv) {
        final inventoryPosition = inv.inventoryPosition.toString();
        return inventoryPosition.contains(query);
      }).toList();
    });
  }

  Future<bool> deleteInventory(
      String inventoryId, int inventoryPosition) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ยืนยันการลบ',
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'คุณต้องการลบ "ช่องที่ $inventoryPosition" หรือไม่?',
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'ลบ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                var resulst = await DatabaseHelper.instance
                    .deleteInventory(context, inventoryId);

                if (resulst) {
                  ScaffoldMessage.show(
                      context,
                      Icons.check_circle_outline_rounded,
                      'ช่องที่ $inventoryPosition ถูกลบแล้ว',
                      's');
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              },
            ),
          ],
        );
      },
    );

    return shouldDelete ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            CustomGap.smallHeightGap,
            SearchWidget(
              searchController: searchController,
              onSearchChanged: _onSearchChanged,
              text: 'ค้นหาช่อง...',
              isNumber: true,
            ),
            CustomGap.smallHeightGap,
            Expanded(
              child: BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  final inventoryList = filteredInventory.isNotEmpty ||
                          searchController.text.isNotEmpty
                      ? filteredInventory
                      : state.inventoryList;
                  if (inventoryList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: inventoryList.length,
                      itemBuilder: (context, index) {
                        final inventory = inventoryList[index];

                        // เช็คจำนวนคงเหลือต่ำกว่า minQty หรือ เท่ากับ 0
                        bool isLowQty =
                            inventory.inventoryQty <= inventory.inventoryMin;
                        bool isOutOfStock = inventory.inventoryQty == 0;

                        return Dismissible(
                          key: Key(inventory.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async =>
                              await deleteInventory(
                            inventory.id,
                            inventory.inventoryPosition,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddInventory(
                                          titleText:
                                              'แก้ไขช่องที่ ${inventory.inventoryPosition}',
                                          inventory: inventory,
                                        ),
                                      ),
                                    );
                                  },
                                  splashColor:
                                      ColorsTheme.primary.withOpacity(0.3),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomGap.smallHeightGap,
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
                                          'จำนวนคงเหลือ ${inventory.inventoryQty.toString()}',
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
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomGap.smallHeightGap,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Min ${inventory.inventoryMin.toString()}',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          CustomGap.smallWidthGap,
                                          Text(
                                            'Max ${inventory.inventoryMAX.toString()}',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  leading: SizedBox(
                                      width: 70.0,
                                      child: Center(
                                        child: Text(
                                          inventory.inventoryPosition
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 48.0,
                                            color: ColorsTheme.grey,
                                          ),
                                        ),
                                      )),
                                  trailing: const Icon(
                                    Icons.navigate_next,
                                    size: 36.0,
                                  ),
                                ),
                                Divider(
                                  thickness: 1.0,
                                  color: Colors.grey[300],
                                  height: 7.0,
                                  indent: 100.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const NoData(
                      icon: Icons.grid_view_sharp,
                      text: 'ไม่พบข้อมูลช่อง',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButton(
        text: 'เพิ่มช่อง',
        icon: Icons.add,
        route: custom_route.Routes.addinventory,
      ),
    );
  }
}
