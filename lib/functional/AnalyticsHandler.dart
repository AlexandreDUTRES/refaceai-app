import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsHandler {
  static void navigation(String name) {
    try {
      FirebaseAnalytics.instance.setCurrentScreen(
        screenName: name,
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static void micPressed(int duration) {
    try {
      FirebaseAnalytics.instance.logEvent(
        name: "mic_pressed",
        parameters: {"duration": (duration / 1000).round()},
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
