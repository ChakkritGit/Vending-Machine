import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_standalone/src/blocs/users/user_bloc.dart';
import 'package:vending_standalone/src/constants/initail_store.dart';
import 'package:vending_standalone/src/models/users/user_model.dart';

class UserDataService {
  List<Map<String, dynamic>> _userData = [];

  List<Map<String, dynamic>> get userData => _userData;

  Future<void> loadUserData() async {
    StoredLocal storage = StoredLocal.instance;
    List<Map<String, dynamic>> userData = await storage.getUserData('userData');
    _userData = userData;
  }

  void updateUserBloc(BuildContext context) {
    if (_userData.isNotEmpty) {
      context.read<UserBloc>().add(
        UserData(
          userData: _userData.map((items) => Users.fromMap(items)).toList(),
        ),
      );
    }
  }
}
