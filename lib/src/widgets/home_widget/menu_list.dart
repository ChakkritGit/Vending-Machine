import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;

class MenuList extends StatelessWidget {
  const MenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      custom_route.Routes.manageStock,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(20),
                    height: 130.0,
                    width: 150.0,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.add_box_rounded,
                          size: 48.0,
                          color: Colors.white,
                        ),
                        CustomGap.smallHeightGap,
                        Text(
                          'เติมยา',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomGap.mediumWidthGap,
                GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print('รายงาน');
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(20),
                    height: 130.0,
                    width: 150.0,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.edit_document,
                          size: 48.0,
                          color: Colors.white,
                        ),
                        CustomGap.smallHeightGap,
                        Text(
                          'รายงาน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomGap.mediumWidthGap,
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      custom_route.Routes.manage,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(20),
                    height: 130.0,
                    width: 150.0,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.manage_accounts,
                          size: 48.0,
                          color: Colors.white,
                        ),
                        CustomGap.smallHeightGap,
                        Text(
                          'จัดการ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomGap.mediumWidthGap,
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      custom_route.Routes.settings,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(20),
                    height: 130.0,
                    width: 150.0,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 48.0,
                          color: Colors.white,
                        ),
                        CustomGap.smallHeightGap,
                        Text(
                          'ตั้งค่า',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
