// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:vending/src/blocs/drug/drug_bloc.dart';
import 'package:vending/src/blocs/inventory/inventory_bloc.dart';
import 'package:vending/src/blocs/machine/machine_bloc.dart';
import 'package:vending/src/blocs/users/user_bloc.dart';
import 'package:vending/src/models/drugs/drug_list_model.dart';
import 'package:vending/src/models/drugs/drug_model.dart';
import 'package:vending/src/models/inventory/inventory.dart';
import 'package:vending/src/models/machine/machine_model.dart';
import 'package:vending/src/models/stocks/stocks.dart';
import 'package:vending/src/models/users/user_model.dart';
import 'package:vending/src/widgets/utils/scaffold_message.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'vd_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // สร้างตาราง
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id TEXT NOT NULL PRIMARY KEY,
      userName TEXT NOT NULL UNIQUE,
      userPassword TEXT NOT NULL,
      userStatus INTEGER NOT NULL,
      userRole TEXT NOT NULL,
      displayName TEXT,
      userImage TEXT,
      question INTEGER NOT NULL,
      answer TEXT NOT NULL,
      comment TEXT,
      createBy TEXT,
      createdAt REAL NOT NULL,
      updatedAt REAL NOT NULL
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS drugs (
      id TEXT NOT NULL PRIMARY KEY,
      drugName TEXT NOT NULL,
      drugUnit TEXT NOT NULL,
      drugImage TEXT NOT NULL,
      drugPriority INTEGER NOT NULL,
      drugStatus INTEGER NOT NULL,
      comment TEXT,
      createdAt REAL NOT NULL,
      updatedAt REAL NOT NULL
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS machine (
      id TEXT NOT NULL PRIMARY KEY,
      machineName TEXT NOT NULL,
      machineStatus INTEGER NOT NULL,
      comment TEXT,
      createdAt REAL NOT NULL,
      updatedAt REAL NOT NULL
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS inventory (
      id TEXT NOT NULL PRIMARY KEY,
      inventoryPosition INTEGER NOT NULL UNIQUE,
      inventoryQty INTEGER NOT NULL,
      inventoryMin INTEGER NOT NULL,
      inventoryMAX INTEGER NOT NULL,
      inventoryStatus INTEGER NOT NULL,
      machineId TEXT NOT NULL,
      comment TEXT,
      createdAt REAL NOT NULL,
      updatedAt REAL NOT NULL,
      FOREIGN KEY(machineId) REFERENCES machine(id)
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS `group` (
      id TEXT NOT NULL PRIMARY KEY,
      drugId TEXT NOT NULL,
      inventoryId TEXT NOT NULL,
      groupStatus INTEGER NOT NULL,
      comment TEXT,
      createdAt REAL NOT NULL,
      updatedAt REAL NOT NULL,
      FOREIGN KEY(drugId) REFERENCES drugs(id),
      FOREIGN KEY(inventoryId) REFERENCES inventory(id)
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS group_inventory (
      id TEXT NOT NULL PRIMARY KEY,
      groupId TEXT NOT NULL,
      inventoryId TEXT NOT NULL,
      FOREIGN KEY(groupId) REFERENCES `group`(id),
      FOREIGN KEY(inventoryId) REFERENCES inventory(id)
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS orders (
    id TEXT NOT NULL PRIMARY KEY,
    userId TEXT NOT NULL,
    drugId TEXT NOT NULL,
    inventoryId TEXT NOT NULL,
    orderQty INTEGER NOT NULL,
    comment TEXT,
    createdAt REAL NOT NULL,
    updatedAt REAL NOT NULL,
    FOREIGN KEY(userId) REFERENCES users(id),
    FOREIGN KEY(drugId) REFERENCES drugs(id),
    FOREIGN KEY(inventoryId) REFERENCES inventory(id)
);
''');
  }

  // การยืนยัน
  Future<List<Map<String, Object?>>> checkLogin(
      BuildContext context, Map<String, dynamic> row) async {
    Database db = await instance.database;
    try {
      final result = await db.query(
        'users',
        where: 'LOWER(userName) = ?',
        whereArgs: [row['userName'].toString().toLowerCase()],
      );

      if (result.isNotEmpty) {
        String inputPassword = row['userPassword'] as String;
        var bytes = utf8.encode(inputPassword.toLowerCase());
        var hashedInputPassword = sha256.convert(bytes).toString();

        String storedPassword = result.first['userPassword'] as String;

        if (hashedInputPassword == storedPassword) {
          final sanitizedResults = result.map((user) {
            final sanitizedUser = Map<String, Object?>.from(user);
            sanitizedUser.remove('userPassword');
            sanitizedUser.remove('question');
            sanitizedUser.remove('answer');
            return sanitizedUser;
          }).toList();

          ScaffoldMessage.show(context, 'ล็อกอินสำเร็จ', true);
          return sanitizedResults;
        } else {
          ScaffoldMessage.show(context, 'รหัสผ่านผิด', false);
          return [];
        }
      } else {
        ScaffoldMessage.show(context, 'ไม่พบผู้ใช้', false);
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // เพิ่ม
  Future<bool> createUser(
      BuildContext context, Map<String, dynamic> row) async {
    Database db = await instance.database;
    try {
      String userName = row['userName'].toLowerCase();

      var existingUser = await db.query(
        'users',
        where: 'LOWER(userName) = ?',
        whereArgs: [userName],
      );

      if (existingUser.isNotEmpty) {
        ScaffoldMessage.show(context, 'ชื่อผู้ใช้นี้มีอยู่แล้ว', false);
        return false;
      }

      String password = row['userPassword'];
      var bytes = utf8.encode(password.toLowerCase());
      var hashedPassword = sha256.convert(bytes).toString();

      row['id'] = 'UID-${const Uuid().v4()}';
      row['userName'] = userName;
      row['userPassword'] = hashedPassword;
      row['userStatus'] = 0;

      await db.insert('users', row);
      await getUsers(context);
      ScaffoldMessage.show(context, 'สร้างผู้ใช้สำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> createDrug(
      BuildContext context, Map<String, dynamic> row) async {
    Database db = await instance.database;

    try {
      String drugName = row['drugName'].toLowerCase();

      var existingDrug = await db.query(
        'drugs',
        where: 'LOWER(drugName) = ?',
        whereArgs: [drugName],
      );

      if (existingDrug.isNotEmpty) {
        ScaffoldMessage.show(context, 'ชื่อยานี้มีอยู่แล้ว', false);
        return false;
      }
      row['id'] = 'DRUG-${const Uuid().v4()}';
      row['drugStatus'] = 0;

      await db.insert('drugs', row);
      await getDrugs(context);
      ScaffoldMessage.show(context, 'เพิ่มยาสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> createMachine(
      BuildContext context, Map<String, dynamic> row) async {
    Database db = await instance.database;

    try {
      String machineName = row['machineName'].toLowerCase();

      var existingMachine = await db.query(
        'machine',
        where: 'LOWER(machineName) = ?',
        whereArgs: [machineName],
      );

      if (existingMachine.isNotEmpty) {
        ScaffoldMessage.show(context, 'ชื่อเครื่องนี้มีอยู่แล้ว', false);
        return false;
      }
      row['id'] = 'MAC-${const Uuid().v4()}';
      row['machineStatus'] = 0;

      await db.insert('machine', row);
      await getMachine(context);
      ScaffoldMessage.show(context, 'เพิ่มเครื่องสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> createInventory(
      BuildContext context, Map<String, dynamic> row) async {
    Database db = await instance.database;

    try {
      var existingPosition = await db.query(
        'inventory',
        where: 'inventoryPosition = ?',
        whereArgs: [row['inventoryPosition']],
      );

      if (existingPosition.isNotEmpty) {
        ScaffoldMessage.show(
          context,
          'ช่องนี้ถูกใช้ไปแล้วกรุณาเลือกช่องอื่น',
          false,
        );
        return false;
      }
      row['id'] = 'INV-${const Uuid().v4()}';
      row['inventoryStatus'] = 0;

      await db.insert('inventory', row);
      await getInventory(context);
      ScaffoldMessage.show(context, 'เพิ่มช่องสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> createGroupAndInventory(
    BuildContext context, {
    required String? drugId,
    required List<Map<String, dynamic>> inventories,
  }) async {
    Database db = await instance.database;

    try {
      var result = await db.transaction((txn) async {
        String groupId = 'GROUP-${const Uuid().v4()}';

        var exitDrug =
            await txn.query('group', where: 'drugId = ?', whereArgs: [drugId]);
        if (exitDrug.isEmpty) {
          await txn.insert('group', {
            'id': groupId,
            'drugId': drugId,
            'inventoryId': inventories[0]['inventoryId'],
            'groupStatus': 0,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });

          for (var inventory in inventories) {
            String inventoryId = inventory['inventoryId'];

            await txn.insert('group_inventory', {
              'id': 'GROUPINV-${const Uuid().v4()}',
              'groupId': groupId,
              'inventoryId': inventoryId,
            });
          }

          await getGroup(context, txn: txn);
          await getInventoryWithDrug(context, txn: txn);

          ScaffoldMessage.show(
              context, 'กรุ๊ปและข้อมูลสต๊อกถูกเพิ่มสำเร็จ', true);
          return true;
        } else {
          ScaffoldMessage.show(context,
              'ไม่สามารถเพิ่มกรุ๊ปได้เนื่องจากยาถูกจัดในกรุ๊ปอื่นแล้ว', false);
          return false;
        }
      });
      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // แก้ไข
  Future<bool> updateUser(
      BuildContext context, Map<String, dynamic> row, String userId) async {
    Database db = await instance.database;

    try {
      await db.update('users', row, where: 'id = ?', whereArgs: [userId]);
      await getUsers(context);
      ScaffoldMessage.show(context, 'แก้ไขผู้ใช้สำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> updateDrug(
      BuildContext context, Map<String, dynamic> row, String? drugId) async {
    Database db = await instance.database;

    try {
      await db.update('drugs', row, where: 'id = ?', whereArgs: [drugId]);
      await getDrugs(context);
      await getGroup(context);
      ScaffoldMessage.show(context, 'แก้ไขยาสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> updateInventory(
      BuildContext context, Map<String, dynamic> row, String? invId) async {
    Database db = await instance.database;

    try {
      await db.update('inventory', row, where: 'id = ?', whereArgs: [invId]);
      await getInventory(context);
      await getGroup(context);
      ScaffoldMessage.show(context, 'แก้ไขช่องสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> updateMachine(
      BuildContext context, Map<String, dynamic> row, String? macId) async {
    Database db = await instance.database;

    try {
      await db.update('machine', row, where: 'id = ?', whereArgs: [macId]);
      await getMachine(context);
      ScaffoldMessage.show(context, 'แก้ไขเครื่องสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> updateGroupAndInventory(BuildContext context, String? gId,
      {required String? drugId,
      required List<Map<String, dynamic>> inventories}) async {
    Database db = await instance.database;

    try {
      var result = await db.transaction((txn) async {
        var exitDrug = await txn.query(
          'group',
          where: 'drugId = ? AND id != ?',
          whereArgs: [drugId, gId],
        );

        if (exitDrug.isEmpty) {
          // อัปเดทยาในกลุ่ม
          await txn.update(
            'group',
            {
              'drugId': drugId,
              'updatedAt': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [gId],
          );

          // ดึงรายการช่องที่มีอยู่ใน group_inventory ของกลุ่มนี้
          var currentInventories = await txn.query(
            'group_inventory',
            where: 'groupId = ?',
            whereArgs: [gId],
          );

          // ดึงรายการ inventoryId ที่มีอยู่ปัจจุบันในตาราง group_inventory
          List<String> currentInventoryIds = currentInventories
              .map((inventory) => inventory['inventoryId'].toString())
              .toList();

          // ดึงรายการ inventoryId ใหม่จากการอัปเดต
          List<String> newInventoryIds = inventories
              .map((inventory) => inventory['inventoryId'].toString())
              .toList();

          // หา inventoryId ที่จะถูกลบออก (ที่มีในตารางแต่ไม่มีในรายการใหม่)
          List<String> inventoriesToRemove = currentInventoryIds
              .where((id) => !newInventoryIds.contains(id))
              .toList();

          // ลบช่องที่ไม่อยู่ในรายการใหม่ออกจาก group_inventory
          for (var inventoryId in inventoriesToRemove) {
            await txn.delete(
              'group_inventory',
              where: 'inventoryId = ? AND groupId = ?',
              whereArgs: [inventoryId, gId],
            );
          }

          // เพิ่มช่องใหม่ถ้ายังไม่มีใน group_inventory
          for (var inventory in inventories) {
            String inventoryId = inventory['inventoryId'];

            var existInvInGroup = await txn.query(
              'group_inventory',
              where: 'inventoryId = ? AND groupId = ?',
              whereArgs: [inventoryId, gId],
            );

            if (existInvInGroup.isEmpty) {
              await txn.insert(
                'group_inventory',
                {
                  'id': 'GROUPINV-${const Uuid().v4()}',
                  'groupId': gId,
                  'inventoryId': inventoryId,
                },
              );
            }
          }

          await getGroup(context, txn: txn);
          await getInventoryWithDrug(context, txn: txn);

          ScaffoldMessage.show(
              context, 'กรุ๊ปและข้อมูลสินค้าคงคลังถูกอัปเดตสำเร็จ', true);
          return true;
        } else {
          ScaffoldMessage.show(context,
              'ไม่สามารถอัปเดตกรุ๊ปได้เนื่องจากยาถูกจัดในกลุ่มอื่นแล้ว', false);
          return false;
        }
      });

      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> updateStock(
      BuildContext context, Map<String, dynamic> row, String? invId) async {
    Database db = await instance.database;

    try {
      await db.update('inventory', row, where: 'id = ?', whereArgs: [invId]);
      await getInventory(context);
      await getGroup(context);
      await getInventoryWithDrug(context);
      ScaffoldMessage.show(context, 'เพิ่มสต๊อกสำเร็จ', true);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // ดึงข้อมูล
  Future<bool> getUsers(BuildContext context) async {
    Database db = await instance.database;
    try {
      final result = await db.query('users',
          columns: [
            'id',
            'userName',
            'userStatus',
            'userRole',
            'displayName',
            'userImage',
            'question',
            'answer',
            'comment',
            'createBy',
            'createdAt',
            'updatedAt'
          ],
          orderBy: 'createdAt DESC');
      if (result.isNotEmpty) {
        List<Users> userList = result.map((map) => Users.fromMap(map)).toList();
        context.read<UserBloc>().add(UserList(userList: userList));
      } else {
        context.read<UserBloc>().add(const UserList(userList: []));
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> getDrugs(BuildContext context) async {
    Database db = await instance.database;
    try {
      final result = await db.query('drugs', orderBy: 'createdAt DESC');
      if (result.isNotEmpty) {
        List<Drugs> drugList = result.map((map) => Drugs.fromMap(map)).toList();
        context.read<DrugBloc>().add(DrugList(drugList: drugList));
      } else {
        context.read<DrugBloc>().add(const DrugList(drugList: []));
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> getMachine(BuildContext context) async {
    Database db = await instance.database;
    try {
      final result = await db.query('machine', orderBy: 'createdAt DESC');
      if (result.isNotEmpty) {
        List<Machines> machineList =
            result.map((map) => Machines.fromMap(map)).toList();
        context.read<MachineBloc>().add(MachineList(machineList: machineList));
      } else {
        context.read<MachineBloc>().add(const MachineList(machineList: []));
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> getInventory(BuildContext context, {Transaction? txn}) async {
    Database db = await instance.database;

    try {
      final result = await (txn != null ? txn.rawQuery('''
      SELECT
        i.id AS inventoryId,
        i.inventoryPosition,
        i.inventoryQty,
        i.inventoryMin,
        i.inventoryMAX,
        i.inventoryStatus,
        i.comment AS inventoryComment,
        i.createdAt AS inventoryCreatedAt,
        i.updatedAt AS inventoryUpdatedAt,
        m.id AS machineId,
        m.machineName,
        m.machineStatus,
        m.comment AS machineComment,
        m.createdAt AS machineCreatedAt,
        m.updatedAt AS machineUpdatedAt
      FROM
        inventory i
      INNER JOIN
        machine m ON i.machineId = m.id
      ORDER BY
        i.inventoryPosition ASC;
    ''') : db.rawQuery('''
      SELECT
        i.id AS inventoryId,
        i.inventoryPosition,
        i.inventoryQty,
        i.inventoryMin,
        i.inventoryMAX,
        i.inventoryStatus,
        i.comment AS inventoryComment,
        i.createdAt AS inventoryCreatedAt,
        i.updatedAt AS inventoryUpdatedAt,
        m.id AS machineId,
        m.machineName,
        m.machineStatus,
        m.comment AS machineComment,
        m.createdAt AS machineCreatedAt,
        m.updatedAt AS machineUpdatedAt
      FROM
        inventory i
      INNER JOIN
        machine m ON i.machineId = m.id
      ORDER BY
        i.inventoryPosition ASC;
    '''));

      if (result.isNotEmpty) {
        List<Inventories> inventoryList =
            result.map((map) => Inventories.fromJoinedMap(map)).toList();
        context
            .read<InventoryBloc>()
            .add(InventoryList(inventoryList: inventoryList));
      } else {
        context
            .read<InventoryBloc>()
            .add(const InventoryList(inventoryList: []));
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> getGroup(BuildContext context, {Transaction? txn}) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> groups = [];

    try {
      final result = await (txn != null ? txn.rawQuery('''
      SELECT
        g.id AS groupId,
        g.drugId,
        d.drugName,
        d.drugImage,
        gi.inventoryId,
        i.inventoryPosition,
        i.inventoryQty,
        i.inventoryMin,
        i.inventoryMax
      FROM `group` g
      INNER JOIN group_inventory gi ON g.id = gi.groupId
      INNER JOIN inventory i ON gi.inventoryId = i.id
      INNER JOIN drugs d ON g.drugId = d.id
      ORDER BY g.id DESC, i.inventoryPosition ASC;
    ''') : db.rawQuery('''
      SELECT
        g.id AS groupId,
        g.drugId,
        d.drugName,
        d.drugImage,
        gi.inventoryId,
        i.inventoryPosition,
        i.inventoryQty,
        i.inventoryMin,
        i.inventoryMax
      FROM `group` g
      INNER JOIN group_inventory gi ON g.id = gi.groupId
      INNER JOIN inventory i ON gi.inventoryId = i.id
      INNER JOIN drugs d ON g.drugId = d.id
      ORDER BY g.id DESC, i.inventoryPosition ASC;
    '''));

      if (result.isNotEmpty) {
        for (var item in result) {
          var existingGroup = groups.firstWhere(
            (group) => group['groupId'] == item['groupId'],
            orElse: () => <String, dynamic>{},
          );

          if (existingGroup.isNotEmpty) {
            existingGroup['inventoryList'].add({
              'inventoryId': item['inventoryId'],
              'inventoryPosition': item['inventoryPosition'],
              'inventoryQty': item['inventoryQty'],
              'inventoryMin': item['inventoryMin'],
              'inventoryMax': item['inventoryMax'],
            });
          } else {
            groups.add({
              'groupId': item['groupId'],
              'drugId': item['drugId'],
              'drugName': item['drugName'],
              'drugImage': item['drugImage'],
              'inventoryList': [
                {
                  'inventoryId': item['inventoryId'],
                  'inventoryPosition': item['inventoryPosition'],
                  'inventoryQty': item['inventoryQty'],
                  'inventoryMin': item['inventoryMin'],
                  'inventoryMax': item['inventoryMax'],
                }
              ]
            });
          }
        }

        List<DrugGroup> groupList =
            groups.map((map) => DrugGroup.fromJson(map)).toList();
        context
            .read<DrugBloc>()
            .add(DrugInventoryList(drugInventoryList: groupList));
      } else {
        context
            .read<DrugBloc>()
            .add(const DrugInventoryList(drugInventoryList: []));
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> getInventoryWithDrug(BuildContext context,
      {Transaction? txn}) async {
    Database db = await instance.database;
    try {
      final result = await (txn != null ? txn.rawQuery('''
      SELECT
    inventory.id AS inventoryId,
    inventory.inventoryPosition,
    inventory.inventoryQty,
    inventory.inventoryMin,
    inventory.inventoryMAX,
    inventory.inventoryStatus,
    drugs.id AS drugId,
    drugs.drugName,
    drugs.drugUnit,
    drugs.drugImage,
    drugs.drugPriority
FROM
    inventory
INNER JOIN
    group_inventory ON inventory.id = group_inventory.inventoryId
INNER JOIN
    `group` ON group_inventory.groupId = `group`.id
INNER JOIN
    drugs ON `group`.drugId = drugs.id
ORDER BY
    inventory.inventoryPosition;
    ''') : db.rawQuery('''
      SELECT
    inventory.id AS inventoryId,
    inventory.inventoryPosition,
    inventory.inventoryQty,
    inventory.inventoryMin,
    inventory.inventoryMAX,
    inventory.inventoryStatus,
    drugs.id AS drugId,
    drugs.drugName,
    drugs.drugUnit,
    drugs.drugImage,
    drugs.drugPriority
FROM
    inventory
INNER JOIN
    group_inventory ON inventory.id = group_inventory.inventoryId
INNER JOIN
    `group` ON group_inventory.groupId = `group`.id
INNER JOIN
    drugs ON `group`.drugId = drugs.id
ORDER BY
    inventory.inventoryPosition;
    '''));

      if (result.isNotEmpty) {
        List<Stocks> userList =
            result.map((map) => Stocks.fromMap(map)).toList();
        context.read<InventoryBloc>().add(StockList(stockList: userList));
      } else {
        context.read<InventoryBloc>().add(const StockList(stockList: []));
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> getDrugsReport(BuildContext context) async {
    Database db = await instance.database;
    try {
      final result = await db.rawQuery('''
      SELECT
        u.userName,
        d.drugName,
        i.inventoryPosition,
        SUM(o.orderQty) AS totalQuantity,
        o.createdAt
      FROM
        orders o
      JOIN
        users u ON o.userId = u.id
      JOIN
        drugs d ON o.drugId = d.id
      JOIN
        inventory i ON o.inventoryId = i.id
      WHERE
        o.createdAt >= datetime('now', '-30 days')
      GROUP BY
        u.userName, d.drugName, i.inventoryPosition, o.createdAt;
    ''');

      if (result.isNotEmpty) {
        ScaffoldMessage.show(context, 'กำลังสร้างรายงาน', true);
        return true;
      } else {
        ScaffoldMessage.show(context, 'ไม่พบรายงาน', false);
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // ดึงตำแหน่ง
  Future<List<int>> getExistingPositions() async {
    Database db = await instance.database;

    try {
      final List<Map<String, dynamic>> result =
          await db.query('inventory', columns: ['inventoryPosition']);
      return result.map((row) => row['inventoryPosition'] as int).toList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<List<String>> getExistingInventory() async {
    Database db = await instance.database;

    try {
      final List<Map<String, dynamic>> result =
          await db.query('group_inventory', columns: ['inventoryId']);
      return result.map((row) => row['inventoryId'] as String).toList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<List<String>> getExistingDrug() async {
    Database db = await instance.database;

    try {
      final List<Map<String, dynamic>> result =
          await db.query('group', columns: ['drugId']);
      return result.map((row) => row['drugId'] as String).toList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDrugForDrop() async {
    Database db = await instance.database;
    try {
      final result = await db.query('drugs', orderBy: 'createdAt DESC');
      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMachineForDrop() async {
    Database db = await instance.database;
    try {
      final result = await db.query('machine', orderBy: 'createdAt DESC');
      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getInventoryForDrop() async {
    Database db = await instance.database;
    try {
      final result = await db.query('inventory', orderBy: 'createdAt DESC');
      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // ลบ
  Future<bool> deleteUser(
      BuildContext context, String userId, String? image) async {
    Database db = await instance.database;
    try {
      var file = File(image!);
      var result =
          await db.delete('users', where: 'id = ?', whereArgs: [userId]);
      if (result == 1) {
        if (file.existsSync()) {
          await file.delete();
        }
        await getUsers(context);
        return true;
      } else {
        ScaffoldMessage.show(context, 'ไม่สามารถลบผู้ใช้ได้', false);
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> deleteDrug(
      BuildContext context, String drugId, String image) async {
    Database db = await instance.database;
    try {
      var file = File(image);

      var result =
          await db.query('group', where: 'drugId = ?', whereArgs: [drugId]);

      if (result.isEmpty) {
        await db.delete('drugs', where: 'id = ?', whereArgs: [drugId]);
        if (file.existsSync()) {
          await file.delete();
        }
        await getDrugs(context);
        return true;
      } else {
        ScaffoldMessage.show(
            context, 'ไม่สามารถลบยาได้เนื่องจากยานี้ถูกจัดกรุ๊ปอยู่', false);
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> deleteMachine(BuildContext context, String machineId) async {
    Database db = await instance.database;
    try {
      var result = await db
          .query('inventory', where: 'machineId = ?', whereArgs: [machineId]);

      if (result.isEmpty) {
        await db.delete('machine', where: 'id = ?', whereArgs: [machineId]);
        await getMachine(context);
        await getInventory(context);
        return true;
      } else {
        ScaffoldMessage.show(
            context,
            'ไม่สามารถลบเครื่องได้เนื่องจากเครื่องนี้ลงทะเบียนกับช่องอยู่',
            false);
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> deleteInventory(BuildContext context, String id) async {
    Database db = await instance.database;
    try {
      var result = await db.transaction(
        (txn) async {
          var result = await txn.query('group_inventory',
              where: 'inventoryId = ?', whereArgs: [id]);

          if (result.isEmpty) {
            await txn.delete('inventory', where: 'id = ?', whereArgs: [id]);
            await getInventory(context, txn: txn);
            return true;
          } else {
            ScaffoldMessage.show(context,
                'ไม่สามารถลบช่องได้เนื่องจากช่องนี้ถูกจัดกรุ๊ปอยู่', false);
            return false;
          }
        },
      );
      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> deleteGroup(BuildContext context, String id) async {
    Database db = await instance.database;
    try {
      var result = await db.transaction(
        (txn) async {
          var res1 = await txn
              .delete('group_inventory', where: 'groupId = ?', whereArgs: [id]);
          var res2 =
              await txn.delete('group', where: 'id = ?', whereArgs: [id]);

          if (res1 >= 1 && res2 >= 1) {
            await getGroup(context, txn: txn);
            await getInventoryWithDrug(context, txn: txn);
            return true;
          } else {
            ScaffoldMessage.show(context, 'ไม่สามารถลบกรุ๊ปได้', false);
            return false;
          }
        },
      );
      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // export database
  Future<int> exportDatabase() async {
    if (await Permission.storage.request().isGranted) {
      try {
        Directory databasesPath = await getApplicationDocumentsDirectory();
        String dbPath = join(databasesPath.path, 'vd_database.db');

        final dbFile = File(dbPath);
        if (await dbFile.exists()) {
          await initializeDateFormatting('th_Th', null);

          String? selectedDirectory =
              await FilePicker.platform.getDirectoryPath();
          if (selectedDirectory != null) {
            final exportPath = join(
              selectedDirectory,
              'vd_database_exported_${DateFormat('dd_MM_yyyy_HH_mm_ss', 'th_Th').format(DateTime.now())}.db',
            );

            final exportFile = File(exportPath);
            await exportFile.writeAsBytes(await dbFile.readAsBytes());

            if (kDebugMode) {
              print('Database exported to $exportPath');
            }
            return 1;
          } else {
            if (kDebugMode) {
              print('Directory selection cancelled.');
            }
            return 3;
          }
        } else {
          if (kDebugMode) {
            print('Database file does not exist at $dbPath');
          }
          return 2;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error exporting database: $e');
        }
        return 0;
      }
    } else {
      if (kDebugMode) {
        print('permission denided');
      }
      return 4;
    }
  }
}
