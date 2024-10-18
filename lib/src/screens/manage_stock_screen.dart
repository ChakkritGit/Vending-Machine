import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending/src/blocs/inventory/inventory_bloc.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/models/stocks/stocks.dart';
import 'package:vending/src/widgets/manage_user_widget/image_file.dart';
import 'package:vending/src/widgets/md_widget/app_bar.dart';
import 'package:vending/src/widgets/utils/no_data.dart';
import 'package:vending/src/widgets/utils/search_widget.dart';

class ManageStockScreen extends StatefulWidget {
  const ManageStockScreen({super.key});

  @override
  State<ManageStockScreen> createState() => _ManageStockScreenState();
}

class _ManageStockScreenState extends State<ManageStockScreen> {
  late TextEditingController searchController;
  List<Stocks> filteredStock = [];

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
    final stockList = context.read<InventoryBloc>().state.stockList;

    setState(() {
      filteredStock = stockList.where((inv) {
        final inventoryPosition = inv.position.toString();
        final drugName = inv.drug?.drugName.toString().toLowerCase();
        return inventoryPosition.contains(query) || drugName!.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        text: 'เติมยา',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SearchWidget(
              searchController: searchController,
              onSearchChanged: _onSearchChanged,
              text: 'ค้นหายา...',
              isNumber: false,
            ),
            CustomGap.smallHeightGap,
            Expanded(
              child: BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  final stockList = filteredStock.isNotEmpty ||
                          searchController.text.isNotEmpty
                      ? filteredStock
                      : state.stockList;
                  if (stockList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: stockList.length,
                      itemBuilder: (context, index) {
                        final stock = stockList[index];
                        return Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => AddInventory(
                                  //       titleText:
                                  //           'แก้ไขช่องที่ ${inventory.inventoryPosition}',
                                  //       inventory: inventory,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                splashColor:
                                    ColorsTheme.primary.withOpacity(0.3),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stock.drug?.drugName != null ? stock.drug!.drugName : '- -',
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'จำนวนคงเหลือ ${stock.qty.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Min ${stock.minQty.toString()}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        CustomGap.smallWidthGap,
                                        Text(
                                          'Max ${stock.maxQty.toString()}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                leading: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: stock.drug?.drugImage != null
                                          ? ImageFile(
                                              file: stock.drug?.drugImage)
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
                                          color: Colors.black.withOpacity(
                                              0.5), // Semi-transparent background
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                8.0), // Match border radius
                                            bottomRight: Radius.circular(
                                                8.0), // Match border radius
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          stock.position
                                              .toString(), // "Pick Image" in Thai
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  size: 36.0,
                                ),
                              ),
                              Divider(
                                thickness: 1.0,
                                color: Colors.grey[300],
                                height: 7.0,
                                indent: 50.0,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const NoData(
                      icon: Icons.grid_view_sharp,
                      text: 'ไม่พบข้อมูลยา',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
