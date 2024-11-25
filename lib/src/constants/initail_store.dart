import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StoredLocal {
  static final StoredLocal instance = StoredLocal._privateConstructor();

  StoredLocal._privateConstructor();

  Future<String?> get storeUserData async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');

    return userData;
  }

  Future<void> saveUserData(String key,List<Map<String, dynamic>> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(userData);
    await prefs.setString(key, jsonString);
  }

  Future<List<Map<String, dynamic>>> getUserData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);

    if (jsonString != null) {
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse.map((item) => item as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }
}
