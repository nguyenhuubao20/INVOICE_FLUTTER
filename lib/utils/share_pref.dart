import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String expireDate = DateFormat("yyyy-MM-dd hh:mm:ss")
      .format(DateTime.now().add(Duration(days: 30)));
  prefs.setString('expireDate', expireDate.toString());
  return prefs.setString('token', value);
}

Future<bool> expireToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(prefs.getString('expireDate') ?? '');
    return tempDate.compareTo(DateTime.now()) < 0;
  } catch (e) {
    return true;
  }
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<String?> getStoreId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('storeId');
}

Future<void> setStoreId(String? storeId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("storeId", storeId.toString());
}

Future<void> setUserId(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final user = userId;
  prefs.setString("userId", jsonEncode(user));
}

Future<String?> getUserId() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? userData = pref.getString("userId");
  if (userData != null) {
    return jsonDecode(userData);
  }
  return null;
}

Future<void> setRole(int role) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("role", role);
}

Future<int?> getRole() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("role");
}

Future<void> setUsername(String username) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("username", username);
}

Future<String?> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("username");
}

Future<void> removeALL() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<String?> getBrandId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("brandId");
}

Future<String?> setBrandId(String? brandId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("brandId");
}
