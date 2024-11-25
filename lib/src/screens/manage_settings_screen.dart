import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/colors.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';
import 'package:vending_standalone/src/configs/routes.dart' as custom_route;

class ManageSettingsScreen extends StatelessWidget {
  const ManageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        text: 'การตั้งค่า',
        isBottom: false,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.topLeft,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        custom_route.Routes.database,
                      );
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
                          Icons.import_export,
                          size: 36.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: const Text(
                      "Export Database",
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
                    height: 7.0,
                    indent: 100.0,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
