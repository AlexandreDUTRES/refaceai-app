import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/model.dart';
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

    _messaging
        .subscribeToTopic(
            "notif_${getGlobalLocale(GlobalNavigator().currentContext).languageCode}")
        .catchError((_) {});
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
