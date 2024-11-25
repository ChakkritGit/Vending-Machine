import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/database/db_helper.dart';
import 'package:vending_standalone/src/screens/profile_screen.dart';
import 'package:vending_standalone/src/widgets/md_widget/app_bar.dart';

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  String title = '';

  Future getUserLogin(String id) async {
    await DatabaseHelper.instance.getLoginLog(context, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: title, isBottom: false),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.userData.isNotEmpty) {
            final user = state.userData[0];

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (title != user.displayName) {
                setState(() {
                  title = user.displayName ?? 'โปรไฟล์';
                });
                getUserLogin(user.id);
              }
            });

            return ProfileScreen(
              userProfile: user,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
