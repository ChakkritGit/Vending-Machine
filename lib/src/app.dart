// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;
import 'package:vending_standalone/src/database/db_helper.dart';

class App extends StatefulWidget {
  final String? userData;
  const App({super.key, required this.userData});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future initialData() async {
    await DatabaseHelper.instance.getUsers(context);
    await DatabaseHelper.instance.getDrugs(context);
    await DatabaseHelper.instance.getInventory(context);
    await DatabaseHelper.instance.getMachine(context);
    await DatabaseHelper.instance.getGroup(context);
    await DatabaseHelper.instance.getInventoryWithDrug(context);
  }

  @override
  void initState() {
    initialData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.userData == null ? '/login' : '/home',
      routes: custom_route.Routes.getAll(),
      title: 'Vending Machine',
      theme: MaterialTheme.theme,
    );
  }
}
