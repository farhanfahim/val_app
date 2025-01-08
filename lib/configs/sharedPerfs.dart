import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._privateConstructor();
  static final SharedPrefs _instance = SharedPrefs._privateConstructor();
  static SharedPrefs get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Example methods to interact with SharedPreferences
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  getBool(String key) {
    return _prefs?.getBool(key);
  }

  setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  clearPrefs() {
    _prefs?.clear();
  }

  clearPrefsSpecific(String key) {
    _prefs?.remove(key);
  }
  // Add other methods for different types as needed
}
