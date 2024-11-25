import 'package:flutter/material.dart';
import 'package:vending_standalone/src/screens/add_group.dart';
import 'package:vending_standalone/src/screens/add_inventory.dart';
import 'package:vending_standalone/src/screens/add_machine.dart';
import 'package:vending_standalone/src/screens/database_screen.dart';
import 'package:vending_standalone/src/screens/manage_main_inventory_screen.dart';
import 'package:vending_standalone/src/screens/manage_machine_screen.dart';
import 'package:vending_standalone/src/screens/manage_profile_screen.dart';
import 'package:vending_standalone/src/screens/manage_settings_screen.dart';
import 'package:vending_standalone/src/screens/manage_stock_screen.dart';
import 'package:vending_standalone/src/screens/screen_index.dart';

class Routes {
  static const home = '/home';
  static const login = '/login';
  static const manage = '/manage';
  static const manageStock = '/manageStock';
  static const user = '/user';
  static const drug = '/drug';
  static const machine = '/machine';
  static const inventory = '/inventory';
  static const adduser = '/adduser';
  static const adddrug = '/adddrug';
  static const addmachine = '/addmachine';
  static const addinventory = '/addinventory';
  static const addgroup = '/addgroup';
  static const settings = '/settings';
  static const profile = '/profile';

  static const database = '/database';

  static Map<String, WidgetBuilder> getAll() => _routes;

  static final Map<String, WidgetBuilder> _routes = {
    home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    manage: (context) => const ManageScreen(),
    manageStock: (context) => const ManageStockScreen(),
    user: (context) => const ManageUserScreen(),
    drug: (context) => const ManageDrugScreen(),
    machine: (context) => const ManageMachineScreen(),
    inventory: (context) => const ManageMainInventoryScreen(),
    adduser: (context) => const AddUserScreen(),
    adddrug: (context) => const AddDrugScreen(),
    addmachine: (context) => const AddMachineScreen(),
    addinventory: (context) => const AddInventory(),
    addgroup: (context) => const AddGroup(),
    settings: (context) => const ManageSettingsScreen(),
    database: (context) => const DatabaseScreen(),
    profile: (context) => const ManageProfileScreen(),
  };
}
