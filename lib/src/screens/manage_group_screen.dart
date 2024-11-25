// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/drug/drug_bloc.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/drugs/drug_list_model.dart';
import 'package:vending_standalone/src/screens/add_group.dart';
import 'package:vending_standalone/src/widgets/manage_user_widget/image_file.dart';
import 'package:vending_standalone/src/widgets/md_widget/floating_button.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';
import 'package:vending_standalone/src/widgets/utils/search_widget.dart';

class ManageGroupScreen extends StatefulWidget {
  const ManageGroupScreen({super.key});

  @override
  State<ManageGroupScreen> createState() => _ManageGroupScreenState();
}

class _ManageGroupScreenState extends State<ManageGroupScreen> {
  late TextEditingController searchController;
  List<DrugGroup> filteredGroups = [];

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
    final groupList = context.read<DrugBloc>().state.drugInventoryList;

    setState(() {
      filteredGroups = groupList.where((grp) {
        final drugName = grp.drugName.toLowerCase();
        final inventoryPosition = grp.inventoryList.toString();
        return drugName.contains(query) || inventoryPosition.contains(query);
      }).toList();
    });
  }

  Future<bool> deleteGroup(String id, String drugName) async {
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
            'คุณต้องการลบกรุ๊ป "$drugName" หรือไม่?',
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
                    await DatabaseHelper.instance.deleteGroup(context, id);

                if (resulst) {
                  ScaffoldMessage.show(
                      context,
                      Icons.check_circle_outline_rounded,
                      'กรุ๊ป $drugName ถูกลบแล้ว',
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            CustomGap.smallHeightGap,
            SearchWidget(
              searchController: searchController,
              onSearchChanged: _onSearchChanged,
              text: 'ค้นหากรุ๊ป...',
              isNumber: false,
            ),
            CustomGap.smallHeightGap,
            Expanded(
              child: BlocBuilder<DrugBloc, DrugState>(
                builder: (context, state) {
                  final groupList = filteredGroups.isNotEmpty ||
                          searchController.text.isNotEmpty
                      ? filteredGroups
                      : state.drugInventoryList;
                  if (groupList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: groupList.length,
                      itemBuilder: (context, index) {
                        final group = groupList[index];
                        return Dismissible(
                          key: Key(group.groupId),
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
                              await deleteGroup(
                            group.groupId,
                            group.drugName,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddGroup(
                                          titleText:
                                              'แก้ไขกรุ๊ป ${group.drugName}',
                                          group: group,
                                        ),
                                      ),
                                    );
                                  },
                                  splashColor:
                                      ColorsTheme.primary.withOpacity(0.3),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        group.drugName,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 3.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Min ${group.groupMin.toString()}',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          CustomGap.smallWidthGap,
                                          Text(
                                            'Max ${group.groupMax.toString()}',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: List.generate(
                                      group.inventoryList.length,
                                      (item) {
                                        var groups = group.inventoryList[item];
                                        return Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: ColorsTheme.primary,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Text(
                                                'ช่องที่ ${groups.inventoryPosition}',
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  color: ColorsTheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            CustomGap.smallWidthGap_1
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  leading: SizedBox(
                                    width: 100.0,
                                    child: Center(
                                      child: ImageFile(file: group.drugImage),
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
                                  indent: 130.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const NoData(
                      icon: Icons.category,
                      text: 'ไม่พบข้อมูลกรุ๊ป',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButton(
        text: 'เพิ่มกรุ๊ป',
        icon: Icons.add,
        route: custom_route.Routes.addgroup,
      ),
    );
  }
}
