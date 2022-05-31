import 'dart:async';

import 'package:ACI/utils/shared_preference/shared_preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  // get shared preference instance
  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  // clear all shared preference values
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // remove shared preference value by key
  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  // store boolean value to shared preference by key
  static Future<void> setBooleanValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // retrieve boolean value from shared preference by key
  static Future<bool?> getBooleanValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // store int value to shared preference by key
  static Future<void> setIntValue(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // retrieve int value from shared preference by key
  static Future<int?> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // store double value to shared preference by key
  static Future<void> setDoubleValue(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  // retrieve double value from shared preference by key
  static Future<double?> getDoubleValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // store string value to shared preference by key
  static Future<void> setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // retrieve string value from shared preference by key
  static Future<String?> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // if check user is loggedin or not
  // static Future<bool> isUserLoggedIn() async {
  //   return getBooleanValue(SharedPreferenceKeys.IS_USER_LOGGED_IN);
  // }

  // set user is loggedin
  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    setBooleanValue(SharedPreferenceKeys.IS_USER_LOGGED_IN, isLoggedIn);
  }

  // get access token

  // set firebase token

  // get firebase token

  // if check user is firebase token sent to server

  // set firebase token sent to server

  // get device id

  // get device id
  static Future<void> setDeviceId(String deviceId) async {
    setStringValue(SharedPreferenceKeys.DEVICE_ID, deviceId);
  }
}
