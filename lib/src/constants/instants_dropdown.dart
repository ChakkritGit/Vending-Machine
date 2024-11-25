import 'package:flutter/material.dart';
import 'package:vending_standalone/src/database/db_helper.dart';

class MachineStatus {
  static final List<Map<String, dynamic>> questions = [
    {'label': 'ใช้งาน', 'value': 0},
    {'label': 'ปิดการใช้งาน', 'value': 1},
  ];
}

class InventoryPosition {
  static List<Map<String, dynamic>> position = List.generate(
    60,
    (index) => {'label': 'ช่องที่ ${index + 1}', 'value': index + 1},
  );

  static Future<List<Map<String, dynamic>>> getAvailablePositions() async {
    final existingPositions =
        await DatabaseHelper.instance.getExistingPositions();
    return position
        .where((position) => !existingPositions.contains(position['value']))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getDrugs(BuildContext context) async {
    final drugValue = await DatabaseHelper.instance.getDrugForDrop();
    return drugValue;
  }

  static Future<List<Map<String, dynamic>>> getMachines(
      BuildContext context) async {
    final machineValue = await DatabaseHelper.instance.getMachineForDrop();
    return machineValue;
  }

  static Future<List<Map<String, dynamic>>> getInventory(
      BuildContext context) async {
    final inventory = await DatabaseHelper.instance.getInventoryForDrop();

    final inventoryValue = await DatabaseHelper.instance.getExistingInventory();
    return inventory
        .where((inventory) => !inventoryValue.contains(inventory['id']))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getAvailableDrug(
      BuildContext context) async {
    final drug = await DatabaseHelper.instance.getDrugForDrop();

    final drugExit = await DatabaseHelper.instance.getExistingDrug();
    return drug
        .where((drug) => !drugExit.contains(drug['id']))
        .toList();
  }
}
