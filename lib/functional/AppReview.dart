import 'dart:async';
import 'package:in_app_review/in_app_review.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';

class AppReview {
  static InAppReview _inAppReview = InAppReview.instance;

  static Future<void> requestReview() async {
    if (SharedPreferencesStorage.getAppReview() != null) return;
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      await SharedPreferencesStorage.storeAppReview(
          DateTime.now().millisecondsSinceEpoch);
    }
  }
}
