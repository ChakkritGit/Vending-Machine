// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/services/serialport.dart';
import 'package:vending_standalone/src/services/user_data_service.dart';
import 'package:vending_standalone/src/widgets/home_widget/app_bar.dart';
import 'package:vending_standalone/src/widgets/home_widget/medicine_list.dart';
import 'package:vending_standalone/src/widgets/home_widget/menu_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserDataService userDataService = UserDataService();
  VendingMachine vending = VendingMachine();
  // late StreamSubscription<List<int>> streamSubscription;
  // bool initail = false;

  @override
  void initState() {
    super.initState();
    // reSetMachine();
    vending.connectPort();
    loadAndSetUserData();
  }

  Future<void> loadAndSetUserData() async {
    await userDataService.loadUserData();
    userDataService.updateUserBloc(context);
  }

  // void reSetMachine() {
  //   vending.writeSerialttyS2("# 1 1 1 -1 2");
  //   if (!initail && vending.ttyS2.isOpen) {
  //     streamSubscription = vending.upcomingDatattyS2().listen(
  //       (data) {
  //         List<String> response = data.map((e) => e.toRadixString(16)).toList();
  //         switch (response.join(',')) {
  //           case '26,31,d,a,32,d,a,31,d,a,31,d,a,35,d,a':
  //             // ลิฟต์ขึ้นและลงแล้ว
  //             vending.writeSerialttyS2('# 1 1 6 10 18');
  //             break;
  //           case '26,31,d,a,32,d,a,36,d,a,31,d,a,31,30,d,a':
  //             // ประตูปิดแล้ว
  //             // สั่งปลดล็อกกลอน
  //             vending.writeSerialttyS2('# 1 1 3 0 5');
  //             break;
  //           case '26,31,d,a,32,d,a,33,d,a,30,d,a,36,d,a':
  //             // ปลอดล็อกกลอนแล้ว
  //             // กลับคืนค่าเริ่มต้น
  //             streamSubscription.cancel();
  //             initail = true;
  //             break;
  //           default:
  //             streamSubscription.cancel();
  //             initail = true;
  //         }
  //       },
  //     );
  //   }
  // }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Container(
        color: ColorsTheme.primary,
        alignment: Alignment.center,
        child: Stack(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.userData.isNotEmpty) {
                  final user = state.userData[0];
                  return Column(
                    children: [
                      user.userRole == 'Admin' ? const MenuList() : Container(),
                      CustomGap.smallHeightGap,
                      Expanded(
                        child: MedicineList(
                          user: user,
                          vending: vending,
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
