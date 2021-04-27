import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<bool> saveStr(String key, String value) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.setString(key, value);
  }

  static Future<bool> saveStrList(String key, List<String> list) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.setStringList(key, list);
  }

  static Future<bool> saveBool(String key, bool value) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.setBool(key, value);
  }

  static Future<bool> saveInt(String key, int num) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.setInt(key, num);
  }

  static Future<String?> getStr(String key) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.getString(key);
  }

  static Future<List<String>?> getStrList(String key) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.getStringList(key);
  }

  static Future<int?> getInt(String key) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.getInt(key);
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.getBool(key);
  }
}
