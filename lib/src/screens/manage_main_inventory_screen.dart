import 'package:flutter/material.dart';
import 'package:vending_standalone/src/screens/manage_group_screen.dart';
import 'package:vending_standalone/src/screens/manage_inventory_screen.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class ManageMainInventoryScreen extends StatefulWidget {
  const ManageMainInventoryScreen({super.key});

  @override
  State<ManageMainInventoryScreen> createState() =>
      _ManageMainInventoryScreenState();
}

class _ManageMainInventoryScreenState extends State<ManageMainInventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'จัดการสต๊อก',
        isBottom: true,
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ManageInventoryScreen(), ManageGroupScreen()],
      ),
    );
  }
}
