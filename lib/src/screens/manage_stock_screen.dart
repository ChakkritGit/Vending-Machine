import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/inventory/inventory_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/stocks/stocks.dart';
import 'package:vending_standalone/src/screens/add_stock.dart';
import 'package:vending_standalone/src/widgets/manage_user_widget/image_file.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';
import 'package:vending_standalone/src/widgets/utils/search_widget.dart';

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
        return inventoryPosition.contains(query) ||
            drugName!.contains(query.toLowerCase());
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

                        // เช็คจำนวนคงเหลือต่ำกว่า minQty หรือ เท่ากับ 0
                        bool isLowQty = stock.qty <= stock.minQty;
                        bool isOutOfStock = stock.qty == 0;

                        return Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddStock(
                                        titleText:
                                            '${stock.drug?.drugName} ช่องที่ ${stock.position}',
                                        stock: stock,
                                      ),
                                    ),
                                  );
                                },
                                splashColor:
                                    ColorsTheme.primary.withOpacity(0.3),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ช่องว่างระหว่างชื่อยาและจำนวนคงเหลือ
                                    Text(
                                      stock.drug?.drugName != null
                                          ? stock.drug!.drugName
                                          : '- -',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CustomGap.smallHeightGap,
                                    // แสดงจำนวนคงเหลือพร้อมสีเตือน
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
                                        'จำนวนคงเหลือ ${stock.qty.toString()}',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // ช่องว่างระหว่างจำนวนคงเหลือและข้อมูล min/max
                                    CustomGap.smallHeightGap,
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
                                leading: SizedBox(
                                    width: 100.0,
                                    child: Center(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            child: ImageFile(
                                                file: stock.drug?.drugImage),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                    0.5), // Semi-transparent background
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      8.0), // Match border radius
                                                  bottomRight: Radius.circular(
                                                      8.0), // Match border radius
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(1.0),
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
                                indent: 125.0,
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
