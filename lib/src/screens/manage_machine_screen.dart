// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/machine/machine_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/machine/machine_model.dart';
import 'package:vending_standalone/src/screens/add_machine.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';
import 'package:vending_standalone/src/widgets/md_widget/floating_button.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';
import 'package:vending_standalone/src/widgets/utils/search_widget.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;

class ManageMachineScreen extends StatefulWidget {
  const ManageMachineScreen({super.key});

  @override
  State<ManageMachineScreen> createState() => _ManageMachineScreenState();
}

class _ManageMachineScreenState extends State<ManageMachineScreen> {
  late TextEditingController searchController;
  List<Machines> filteredMachine = [];

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
    final query = searchController.text.toLowerCase();
    final machineList = context.read<MachineBloc>().state.machineList;

    setState(() {
      filteredMachine = machineList.where((mac) {
        final machineName = mac.machineName.toLowerCase();
        return machineName.contains(query);
      }).toList();
    });
  }

  Future<bool> deleteMachine(String id, String name) async {
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
            'คุณต้องการลบ "เครื่อง $name" หรือไม่?',
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
                var resulst =
                    await DatabaseHelper.instance.deleteMachine(context, id);

                if (resulst) {
                  ScaffoldMessage.show(
                      context,
                      Icons.check_circle_outline_rounded,
                      'เครื่อง $name ถูกลบแล้ว',
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
      appBar: const CustomAppBar(
        text: 'จัดการเครื่อง',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SearchWidget(
              searchController: searchController,
              onSearchChanged: _onSearchChanged,
              text: 'ค้นหาเครื่อง...',
              isNumber: false,
            ),
            Expanded(
              child: BlocBuilder<MachineBloc, MachineState>(
                builder: (context, state) {
                  final machineList = filteredMachine.isNotEmpty ||
                          searchController.text.isNotEmpty
                      ? filteredMachine
                      : state.machineList;
                  if (machineList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: machineList.length,
                      itemBuilder: (context, index) {
                        final machine = machineList[index];
                        return Dismissible(
                            key: Key(machine.id),
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
                                await deleteMachine(
                                    machine.id, machine.machineName),
                            child: Material(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddMachineScreen(
                                            titleText: 'แก้ไขเครื่อง',
                                            machine: machine,
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      machine.machineName,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomGap.smallHeightGap,
                                        machine.machineStatus == 0
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 8.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    color: ColorsTheme.primary,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'ใช้งานอยู่',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: ColorsTheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 8.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    color: ColorsTheme.error,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'ปิดการใช้งาน',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: ColorsTheme.error,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    leading: const SizedBox(
                                      width: 70.0,
                                      child: Center(
                                        child: Icon(
                                          Icons.build_circle_sharp,
                                          size: 52.0,
                                          color: ColorsTheme.grey,
                                        ),
                                      ),
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
                                    indent: 100.0,
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  } else {
                    return const NoData(
                      icon: Icons.build_circle_sharp,
                      text: 'ไม่พบข้อมูลเครื่อง',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButton(
        text: 'เพิ่มเครื่อง',
        icon: Icons.add,
        route: custom_route.Routes.addmachine,
      ),
    );
  }
}
