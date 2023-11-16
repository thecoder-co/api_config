import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> removeToken() async {
    await prefs.remove('token');
  }

  static Future<void> setToken(String token) async {
    await prefs.setString('token', token);
  }

  static String? get token {
    return prefs.getString('token');
  }

  static Future<void> setOnboarded(bool isOnboarded) async {
    await prefs.setBool('isOnboarded', isOnboarded);
  }

  static bool get isOnboarded {
    return prefs.getBool('isOnboarded') ?? false;
  }
}
