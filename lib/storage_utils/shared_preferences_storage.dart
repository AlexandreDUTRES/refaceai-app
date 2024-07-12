library shared_preferences_storage;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  // ONBOARDING TOUR
  static Future<void> storeOnboardingTour(bool val) async {
    await _prefs.setBool("onboarding_tour", val);
  }

  static bool getOnboardingTour() {
    bool? val = _prefs.getBool("onboarding_tour");
    return val == true;
  }

  // SAVED PICTURES
  static Future<void> storeSavedPictures(Map<String, String> val) async {
    await _prefs.setString("saved_pictures", json.encode(val));
  }

  static Map<String, String> getSavedPictures() {
    String? val = _prefs.getString("saved_pictures");
    if (val == null) return {};
    return Map<String, String>.from(json.decode(val));
  }
}
