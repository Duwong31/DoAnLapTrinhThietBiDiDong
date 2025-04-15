import 'package:shared_preferences/shared_preferences.dart';

import 'string.dart';

class Preferences {
  factory Preferences() => _instance;

  Preferences._internal();

  static final Preferences _instance = Preferences._internal();

  static late SharedPreferences _pref;

  static Future<void> setPreferences() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() {
    return _pref.clear();
  }

  static bool containsKey(String key) {
    return _pref.containsKey(key);
  }

  static dynamic get(String key) {
    return _pref.get(key);
  }

  static bool getBool(String key) {
    return _pref.getBool(key)!;
  }

  static double getDouble(String key) {
    return _pref.getDouble(key)!;
  }

  static int getInt(String key) {
    return _pref.getInt(key)!;
  }

  static Set<String> getKeys() {
    return _pref.getKeys();
  }

  static String? getString(String key) {
    return _pref.getString(key);
  }

  static List<String>? getStringList(String key) {
    return _pref.getStringList(key);
  }

  static Future<void> reload() {
    return _pref.reload();
  }

  static Future<bool> remove(String key) {
    return _pref.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return _pref.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return _pref.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return _pref.setInt(key, value);
  }

  static void setString(String key, String value) {
    _pref.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return _pref.setStringList(key, value);
  }

  static bool isAuth() => _pref.containsKey(StringUtils.token);

  static bool isV1() => _pref.getString(StringUtils.versionApp) == 'v1';

  static String get currentUser => _pref.getString(StringUtils.currentId) ?? '';
}
