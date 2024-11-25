import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';
import 'package:vending_standalone/src/widgets/utils/no_data.dart';

class ProfileScreen extends StatelessWidget {
  final Users userProfile;
  const ProfileScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: ClipOval(
                    child: userProfile.userImage != null
                        ? Image.file(
                            File(userProfile.userImage!),
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
                CustomGap.mediumWidthGap,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.displayName.toString(),
                      style: const TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${userProfile.userName}',
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    CustomGap.mediumHeightGap,
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 60.0,
                      decoration: CustomInputStyle.buttonBoxdecoration,
                      child: TextButton(
                        onPressed: () => {},
                        child: const Text(
                          "แก้ไข",
                          style: CustomInputStyle.textButtonStyle,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            CustomGap.largeHeightGap,
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'บันทึกการเข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomGap.smallHeightGap,
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  final userLoginList = state.userLoginLog;
                  if (userLoginList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: userLoginList.length,
                      itemBuilder: (context, index) {
                        final data = userLoginList[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                DateFormat('dd MMM yyyy, HH:mm')
                                    .format(data.createdAt),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              leading: SizedBox(
                                width: 70.0,
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[300],
                              height: 7.0,
                              indent: 100.0,
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const NoData(
                      icon: Icons.person_2_rounded,
                      text: 'ไม่พบข้อมูลล็อกอิน',
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
