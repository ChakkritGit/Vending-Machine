import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        text: 'การจัดการ',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => {
                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          custom_route.Routes.user,
                        )
                      },
                      splashColor: ColorsTheme.primary.withOpacity(0.3),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          color: ColorsTheme.primary,
                          child: const Icon(
                            Icons.people,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: const Text(
                        "จัดการผู้ใช้",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minTileHeight: 80.0,
                      horizontalTitleGap: 25.0,
                      trailing: const Icon(
                        Icons.navigate_next,
                        size: 36.0,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.grey[300],
                      height: 0.0,
                      indent: 100.0,
                    ),
                    ListTile(
                      onTap: () => {
                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          custom_route.Routes.drug,
                        )
                      },
                      splashColor: ColorsTheme.primary.withOpacity(0.3),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          color: ColorsTheme
                              .primary, // Add the same color or a different one
                          child: const Icon(
                            Icons.medical_information,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: const Text(
                        "จัดการยา",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minTileHeight: 80.0,
                      horizontalTitleGap: 25.0,
                      trailing: const Icon(
                        Icons.navigate_next,
                        size: 36.0,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.grey[300],
                      height: 0.0,
                      indent: 100.0,
                    ),
                    ListTile(
                      onTap: () => {
                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          custom_route.Routes.inventory,
                        )
                      },
                      splashColor: ColorsTheme.primary.withOpacity(0.3),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          color: ColorsTheme
                              .primary, // Add the same color or a different one
                          child: const Icon(
                            Icons.shopping_basket_rounded,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: const Text(
                        "จัดการสต๊อก",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minTileHeight: 80.0,
                      horizontalTitleGap: 25.0,
                      trailing: const Icon(
                        Icons.navigate_next,
                        size: 36.0,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.grey[300],
                      height: 0.0,
                      indent: 100.0,
                    ),
                    ListTile(
                      onTap: () => {
                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          custom_route.Routes.machine,
                        )
                      },
                      splashColor: ColorsTheme.primary.withOpacity(0.3),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          color: ColorsTheme
                              .primary, // Add the same color or a different one
                          child: const Icon(
                            Icons.build_circle_sharp,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: const Text(
                        "จัดการเครื่อง",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minTileHeight: 80.0,
                      horizontalTitleGap: 25.0,
                      trailing: const Icon(
                        Icons.navigate_next,
                        size: 36.0,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.grey[300],
                      height: 0.0,
                      indent: 100.0,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
