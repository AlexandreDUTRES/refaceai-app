import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:photogenerator/app_ui/utils.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Globals {
  static String get appName => FlutterConfig.get("APP_NAME");
  static String get appIdentifier => FlutterConfig.get("APP_IDENTIFIER");
  static String get appIosIdentifier => FlutterConfig.get("APP_IOS_IDENTIFIER");

  static List<Locale> get supportedLocales =>
      List<Locale>.from(FlutterConfig.get("SUPPORTED_LOCALES")
          .split(",")
          .map((e) => localeFromString(e)));

  static String get apiUrl => FlutterConfig.get("API_URL");

  static String get adMobAdUnitId => FlutterConfig.get(
      isAndroid ? "AD_MOB_ANDROID_AD_UNIT_ID" : "AD_MOB_IOS_AD_UNIT_ID");

  // late variables
  static late String appVersion;
  static late String appVersionWithBuildNumber;

  static Future<void> initializeLateVariables() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    appVersionWithBuildNumber = "$appVersion+${packageInfo.buildNumber}";
  }
}
