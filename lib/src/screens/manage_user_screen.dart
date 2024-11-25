// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';
import 'package:vending_standalone/src/screens/screen_index.dart';
import 'package:vending_standalone/src/widgets/manage_user_widget/image_file.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';
import 'package:vending_standalone/src/widgets/md_widget/floating_button.dart';
import 'package:vending_standalone/src/widgets/utils/scaffold_message.dart';
import 'package:vending_standalone/src/widgets/utils/search_widget.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageUserScreenState createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  late TextEditingController searchController;
  List<Users> filteredUsers = [];

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
    final userList = context.read<UserBloc>().state.userList;
    final userData = context.read<UserBloc>().state.userData;

    setState(() {
      filteredUsers = userList.where((user) {
        final userName = user.userName.toLowerCase();
        final displayName = user.displayName?.toLowerCase() ?? '';
        final id = user.id;
        return (userName.contains(query) || displayName.contains(query)) &&
            id != userData[0].id;
      }).toList();
    });
  }

  Future<bool> deleteUser(String userId, String userName, String? image) async {
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
            'คุณต้องการลบ $userName หรือไม่?',
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
                    .deleteUser(context, userId, image);

                if (resulst) {
                  ScaffoldMessage.show(
                      context,
                      Icons.check_circle_outline_rounded,
                      'ผู้ใช้ $userName ถูกลบแล้ว',
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
        text: 'จัดการผู้ใช้',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SearchWidget(
              searchController: searchController,
              onSearchChanged: _onSearchChanged,
              text: 'ค้นหาผู้ใช้...',
              isNumber: false,
            ),
            CustomGap.smallHeightGap,
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  final filteredInitialUserList = state.userList.where((user) {
                    if (state.userData.isNotEmpty) {
                      return user.id != state.userData[0].id;
                    } else {
                      return true;
                    }
                  }).toList();

                  final userList = filteredUsers.isNotEmpty ||
                          searchController.text.isNotEmpty
                      ? filteredUsers
                      : filteredInitialUserList;
                  if (userList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        final user = userList[index];
                        return Dismissible(
                          key: Key(user.id),
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
                          confirmDismiss: (direction) async => await deleteUser(
                              user.id, user.userName, user.userImage),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddUserScreen(
                                          titleText: 'แก้ไขผู้ใช้',
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  splashColor:
                                      ColorsTheme.primary.withOpacity(0.3),
                                  title: Text(
                                    user.userName,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    user.displayName ?? 'No display name',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  leading: SizedBox(
                                    width: 100.0,
                                    child: Center(
                                      child: ImageFile(file: user.userImage!),
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
                      icon: Icons.people,
                      text: 'ไม่พบข้อมูลผู้ใช้',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButton(
        text: 'เพิ่มผู้ใช้',
        icon: Icons.add,
        route: custom_route.Routes.adduser,
      ),
    );
  }
}
