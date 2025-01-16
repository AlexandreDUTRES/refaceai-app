import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsHandler {
  static void navigation(String name) {
    try {
      FirebaseAnalytics.instance.logScreenView(
        screenName: name,
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
