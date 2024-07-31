import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late SharedPreferences prefs;

  static setStringPref({required String key, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static String? getStringPref({required String key}) {
    return prefs.getString(key) ?? "";
  }

  static removePref({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static setBoolPref({required String key, required bool value}) {
    return prefs.setBool(key, value);
  }

  static bool? getBoolPref({required String key}) {
    return prefs.getBool(key);
  }

  static void clearPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
