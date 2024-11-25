// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/drug/drug_bloc.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/drugs/drug_model.dart';
import 'package:vending_standalone/src/screens/add_drug.dart';
import 'package:vending_standalone/src/widgets/manage_user_widget/image_file.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';
import 'package:vending_standalone/src/widgets/md_widget/floating_button.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';
import 'package:vending_standalone/src/widgets/utils/search_widget.dart';

class ManageDrugScreen extends StatefulWidget {
  const ManageDrugScreen({super.key});

  @override
  State<ManageDrugScreen> createState() => _ManageDrugScreenState();
}

class _ManageDrugScreenState extends State<ManageDrugScreen> {
  late TextEditingController searchController;
  List<Drugs> filteredDrug = [];

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
    final drugList = context.read<DrugBloc>().state.drugList;

    setState(() {
      filteredDrug = drugList.where((drug) {
        final drugName = drug.drugName.toLowerCase();
        final drugUnit = drug.drugUnit.toLowerCase();
        return drugName.contains(query) || drugUnit.contains(query);
      }).toList();
    });
  }

  Future<bool> deleteDrug(String id, String name, String image) async {
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
            'คุณต้องการลบ "ยา $name" หรือไม่?',
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
                var resulst = await DatabaseHelper.instance
                    .deleteDrug(context, id, image);

                if (resulst) {
                  ScaffoldMessage.show(
                      context,
                      Icons.check_circle_outline_rounded,
                      'ยา $name ถูกลบแล้ว',
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
        text: 'จัดการยา',
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
              child: BlocBuilder<DrugBloc, DrugState>(
                builder: (context, state) {
                  final drugList = filteredDrug.isNotEmpty ||
                          searchController.text.isNotEmpty
                      ? filteredDrug
                      : state.drugList;
                  if (drugList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: drugList.length,
                      itemBuilder: (context, index) {
                        final drug = drugList[index];
                        return Dismissible(
                          key: Key(drug.id),
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
                          confirmDismiss: (direction) async => await deleteDrug(
                              drug.id, drug.drugName, drug.drugImage),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddDrugScreen(
                                          titleText: 'แก้ไขยา',
                                          drug: drug,
                                        ),
                                      ),
                                    );
                                  },
                                  splashColor:
                                      ColorsTheme.primary.withOpacity(0.3),
                                  title: Text(
                                    drug.drugName,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        drug.drugUnit,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      CustomGap.smallHeightGap,
                                      drug.drugPriority == 1
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: ColorsTheme.error,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: const Text(
                                                'ยาสำคัญสูง',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: ColorsTheme.error,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      // CustomGap.smallHeightGap,
                                    ],
                                  ),
                                  leading: SizedBox(
                                    width: 100.0,
                                    child: Center(
                                      child: ImageFile(file: drug.drugImage),
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
                      icon: Icons.medical_information,
                      text: 'ไม่พบข้อมูลยา',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButton(
        text: 'เพิ่มยา',
        icon: Icons.add,
        route: custom_route.Routes.adddrug,
      ),
    );
  }
}
