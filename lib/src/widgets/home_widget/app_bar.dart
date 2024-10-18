import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending/src/blocs/users/user_bloc.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/configs/routes.dart' as custom_route;
import 'package:vending/src/widgets/utils/scaffold_message.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "สวัสดีตอนเช้า,";
    } else if (hour >= 12 && hour < 17) {
      return "สวัสดีตอนบ่าย,";
    } else if (hour >= 17 && hour < 20) {
      return "สวัสดีตอนเย็น,";
    } else {
      return "สวัสดีตอนกลางคืน,";
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ยืนยันการออกจากระบบ',
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'คุณแน่ใจหรือว่าต้องการออกจากระบบ?',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (await prefs.remove('userData')) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamedAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    custom_route.Routes.login,
                    (route) => false,
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  ScaffoldMessage.show(
                    // ignore: use_build_context_synchronously
                    context,
                    'ไม่สามารถออกจากระบบได้',
                    false,
                  );
                }
              },
              child: const Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state.userData.isNotEmpty) {
                final user = state.userData[0];
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('Image tapped!');
                        }
                      },
                      child: Container(
                        width: 85.0,
                        height: 85.0,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3.0),
                        ),
                        child: ClipOval(
                          child: user.userImage != null
                              ? Image.file(
                                  File(user.userImage!),
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "lib/src/assets/images/user_placeholder.png",
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    CustomGap.mediumWidthGap,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreetingMessage(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        CustomGap.smallHeightGap,
                        SizedBox(
                          width: 500.0,
                          child: Text(
                            user.displayName ?? 'No display name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          IconButton(
            padding: CustomPadding.paddingAll_15,
            onPressed: () => _showLogoutConfirmationDialog(context),
            icon: const Icon(
              Icons.logout,
              size: 46.0,
              color: Colors.white,
            ),
            focusColor: ColorsTheme.primary,
          )
        ],
      ),
      backgroundColor: ColorsTheme.primary,
      toolbarHeight: 130.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130.0);
}
