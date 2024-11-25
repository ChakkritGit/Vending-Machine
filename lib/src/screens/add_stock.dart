import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/stocks/stocks.dart';
import 'package:vending_standalone/src/widgets/manage_inventory_group/add_stock_form.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class AddStock extends StatefulWidget {
  final String? titleText;
  final Stocks? stock;
  const AddStock({super.key, this.stock, this.titleText});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.titleText.toString(),
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: CustomPadding.paddingAll_15,
          child: Form(
            child: AddStockForm(
              stock: widget.stock,
            ),
          ),
        ),
      ),
    );
  }
}
