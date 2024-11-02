import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';
import 'package:photogenerator/utils/Common.dart';

class FcmHandler {
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    try {
      await _messaging.setAutoInitEnabled(true);
    } catch (_) {}

    final String? lastTopic = await SharedPreferencesStorage.getFcmTopic();
    final String topic =
        "notif_${getGlobalLocale(GlobalNavigator().currentContext).languageCode}_${DateTime.now().timeZoneOffset.inHours}${kDebugMode ? '_debug' : ''}";

    if (lastTopic != topic) {
      if (kDebugMode) print('Unsubcribe to topic: $lastTopic');
      try {
        await _messaging.unsubscribeFromTopic(lastTopic!);
      } catch (_) {}
    }

    if (kDebugMode) print('Subcribe to topic: $topic');
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (_) {}
    await SharedPreferencesStorage.storeFcmTopic(topic);
  }

  static Future<void> interactWithInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage == null) return;

    if (initialMessage.data.containsKey('model')) {
      Model model = blocManager.modelBloc.blocData!.allModels
          .firstWhere((Model m) => m.id == initialMessage.data['model']);
      return await Common.goToModelPage(model);
    }
  }
}
