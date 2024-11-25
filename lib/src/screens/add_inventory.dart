// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/instants_dropdown.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/inventory/inventory.dart';
import 'package:vending_standalone/src/widgets/manage_inventory_group/add_inventory_form.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class AddInventory extends StatefulWidget {
  final String? titleText;
  final Inventories? inventory;
  const AddInventory({super.key, this.titleText, this.inventory});

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  List<Map<String, dynamic>> availablePositions = [];
  List<Map<String, dynamic>> drugs = [];
  List<Map<String, dynamic>> machines = [];

  Future<void> loadData() async {
    availablePositions = await InventoryPosition.getAvailablePositions();
    drugs = await InventoryPosition.getDrugs(context);
    machines = await InventoryPosition.getMachines(context);
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.titleText ?? 'เพิ่มช่อง',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: CustomPadding.paddingAll_15,
          child: Form(
            child: AddInventoryForm(
              machines: machines,
              availablePositions: availablePositions,
              inventory: widget.inventory,
            ),
          ),
        ),
      ),
    );
  }
}
