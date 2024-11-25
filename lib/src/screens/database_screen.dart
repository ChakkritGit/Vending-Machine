// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class DatabaseScreen extends StatelessWidget {
  const DatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        text: 'Export Database',
        isBottom: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.white,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.file_copy_rounded,
              size: 128.0,
              color: Colors.grey,
            ),
            CustomGap.largeHeightGap,
            Container(
              width: CustomInputStyle.inputWidth,
              height: CustomInputStyle.inputHeight,
              decoration: CustomInputStyle.buttonBoxdecoration,
              child: TextButton(
                onPressed: () async {
                  final res = await DatabaseHelper.instance.exportDatabase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: res == 1 ? Colors.green : Colors.red,
                      content: Text(res == 1
                          ? 'Exported successfully'
                          : res == 2
                              ? 'Database file does not exist at'
                              : res == 3
                                  ? 'Exported cancelled'
                                  : res == 4
                                      ? 'Permission denided'
                                      : 'Error exporting database'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  "Export Database",
                  style: CustomInputStyle.textButtonStyle,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
