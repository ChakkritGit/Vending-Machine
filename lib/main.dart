import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/app.dart';
import 'package:vending_standalone/src/blocs/drug/drug_bloc.dart';
import 'package:vending_standalone/src/blocs/inventory/inventory_bloc.dart';
import 'package:vending_standalone/src/blocs/machine/machine_bloc.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/constants/initail_store.dart';
import 'package:vending_standalone/src/constants/style.dart';
import 'package:vending_standalone/src/database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  String? userData = await StoredLocal.instance.storeUserData;
  await DatabaseHelper.instance.database;
  final userBloc = BlocProvider<UserBloc>(create: (context) => UserBloc());
  final drugBloc = BlocProvider<DrugBloc>(create: (context) => DrugBloc());
  final machineBloc =
      BlocProvider<MachineBloc>(create: (context) => MachineBloc());
  final inventoryBloc =
      BlocProvider<InventoryBloc>(create: (context) => InventoryBloc());

  runApp(
    AnnotatedRegion(
      value: SystemUiStyle.overlayStyle,
      child: MultiBlocProvider(
        providers: [
          userBloc,
          drugBloc,
          machineBloc,
          inventoryBloc
        ],
        child: App(userData: userData),
      ),
    ),
  );
}
