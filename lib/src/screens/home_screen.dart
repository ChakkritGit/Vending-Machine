import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending/src/blocs/users/user_bloc.dart';
import 'package:vending/src/constants/colors.dart';
import 'package:vending/src/constants/style.dart';
import 'package:vending/src/services/user_data_service.dart';
import 'package:vending/src/widgets/home_widget/app_bar.dart';
import 'package:vending/src/widgets/home_widget/medicine_list.dart';
import 'package:vending/src/widgets/home_widget/menu_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _loadAndSetUserData();
  }

  Future<void> _loadAndSetUserData() async {
    await _userDataService.loadUserData();
    // ignore: use_build_context_synchronously
    _userDataService.updateUserBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Container(
        color: ColorsTheme.primary,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.userData.isNotEmpty) {
                  final user = state.userData[0];
                  return user.userRole == 'Admin'
                      ? const MenuList()
                      : Container();
                } else {
                  return Container();
                }
              },
            ),
            CustomGap.smallHeightGap,
            const Expanded(
              child: MedicineList()
            ),
          ],
        ),
      ),
    );
  }
}
