import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/hexstring.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/storage_utils/secure_locale_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class Common {
  static void showSnackbar([String? msg]) {
    BuildContext context = GlobalNavigator().currentContext;
    try {
      AppThemeV2 _appTheme = AppThemeV2.of(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg ?? "Une erreur est survenue, veuillez réessayer plus tard",
            style: _appTheme.fonts.body.background.style,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: _appTheme.palette.textColor.withOpacity(0.8),
        ),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<String> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    if (deviceId != null) return deviceId;

    String? storedDeviceId = await SecureLocaleStorage.getDeviceId();
    if (storedDeviceId != null) return storedDeviceId;

    String newDeviceId = Uuid().v4();
    await SecureLocaleStorage.storeDeviceId(newDeviceId);
    return newDeviceId;
  }

  static HexString hashSHA256(String data) {
    return HexString.fromBytes(sha256.convert(utf8.encode(data)).bytes);
  }

  static Future<void> launchURL(String urlString) async {
    Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri))
      // ignore: deprecated_member_use
      await launch(
        urlString,
        forceSafariVC: false,
      );
  }

  static Future<void> goToGenerationPage(Generation generation) async {
    List<Generation> generations =
        blocManager.generationBloc.blocData!.sortedGenerations;
    await GlobalNavigator().navigate(
      "/GenerationPage",
      args: {
        "generations": generations,
        "index": generations.indexWhere((g) => g.id == generation.id),
      },
    );
  }

  static Future<void> goToModelPage(Model model) async {
    List<Model> models = blocManager.modelBloc.blocData!.categories
        .firstWhere((c) => c.models.indexWhere((m) => m.id == model.id) != -1)
        .models;
    await GlobalNavigator().navigate(
      "/ModelPage",
      args: {
        "models": models,
        "index": models.indexWhere((m) => m.id == model.id),
      },
    );
  }
}
