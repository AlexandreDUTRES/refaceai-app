library shared_preferences_storage;

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

  // AD WARNING
  static Future<void> storeAdWarning(bool val) async {
    await _prefs.setBool("ad_warning", val);
  }

  static bool getAdWarning() {
    bool? val = _prefs.getBool("ad_warning");
    return val == true;
  }

  // APP REVIEW
  static Future<void> storeAppReview(int val) async {
    await _prefs.setInt("app_review", val);
  }

  static int? getAppReview() {
    return _prefs.getInt("app_review");
  }

  // SAVED PICTURES
  // static Future<void> storeSavedPictures(Map<String, String> val) async {
  //   await _prefs.setString("saved_pictures", json.encode(val));
  // }

  // static Map<String, String> getSavedPictures() {
  //   String? val = _prefs.getString("saved_pictures");
  //   if (val == null) return {};
  //   return Map<String, String>.from(json.decode(val));
  // }

  // FCM TOPIC
  static Future<void> storeFcmTopic(String topic) async {
    await _prefs.setString("fcm_topic", topic);
  }

  static String? getFcmTopic() {
    return _prefs.getString("fcm_topic");
  }
}
