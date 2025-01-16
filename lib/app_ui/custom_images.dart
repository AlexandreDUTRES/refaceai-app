// ignore_for_file: non_constant_identifier_names, constant_identifier_names

library custom_images;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class CustomImages {
  static Future<void> _precacheImage(BuildContext context, String path) async {
    await precacheImage(
      AssetImage(path),
      context,
    );
  }

  static Future<void> _precacheSvg(String path) async {
    SvgAssetLoader loader = SvgAssetLoader(path);
    await svg.cache
        .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }

  static Future<void> _precacheLottie(String path) async {
    AssetLottie loader = AssetLottie(path);
    await Lottie.cache.putIfAbsent(path, () => loader.load());
  }

  static Future<void> precacheImages(BuildContext context) async {
    List<Future> imageFutures = CustomPngs.values
        .map((dynamic e) => _precacheImage(context, e.path))
        .toList();
    List<Future> lottieFutures =
        CustomLotties.values.map((e) => _precacheLottie(e.path)).toList();
    List<Future> svgFutures =
        CustomSvgs.values.map((e) => _precacheSvg(e.path)).toList();
    await Future.wait([
      ...imageFutures,
      ...lottieFutures,
      ...svgFutures,
    ]);

    if (kDebugMode) {
      print(
          "images cached: ${PaintingBinding.instance.imageCache.liveImageCount}");
      print("lotties cached: ${Lottie.cache.count}");
      print("svgs cached: ${svg.cache.count}");
    }
  }
}

enum CustomSvgs {
  logo__logo,
  logo__logo_txt;

  static String _getFilePackagePath(String name) {
    return "assets/images/$name.svg";
  }

  String get path => _getFilePackagePath(
      toString().replaceFirst("CustomSvgs.", "").split("__").join("/"));

  Widget build({
    required double size,
    required Color color,
    bool noHeight = false,
    bool noWidth = false,
  }) {
    return SizedBox(
      width: noWidth ? null : size,
      height: noHeight ? null : size,
      child: SvgPicture.asset(
        path,
        // ignore: deprecated_member_use
        color: color,
      ),
    );
  }

  Future<ByteData> get byteData => rootBundle.load(path);
}

enum CustomPngs {
  logo__logo_shadowed,
  onboardings__onboarding_1,
  onboardings__onboarding_2,
  onboardings__onboarding_3,
  onboardings__onboarding_4,
  others__free_gain,
  others__small_gain,
  others__medium_gain,
  others__big_gain,
  others__face_mask,
  others__icon_facebook,
  others__icon_instagram,
  others__icon_share,
  others__icon_whatsapp,
  others__smiley_dissatisfied,
  others__smiley_neutral,
  others__smiley_satisfied,
  others__smiley_very_dissatisfied,
  others__smiley_very_satisfied,
  others__splash_background;

  static String _getFilePackagePath(String name) {
    return "assets/images/$name.png";
  }

  String get path => _getFilePackagePath(
      toString().replaceFirst("CustomPngs.", "").split("__").join("/"));

  ImageProvider get provider => AssetImage(path);

  Widget build({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        path,
        fit: fit,
      ),
    );
  }

  Future<ByteData> get byteData => rootBundle.load(path);
}

enum CustomLotties {
  animated__ad,
  animated__ghost,
  animated__loader,
  animated__message;

  static String _getFilePackagePath(String name) {
    return "assets/images/$name.json";
  }

  String get path => _getFilePackagePath(
      toString().replaceFirst("CustomLotties.", "").split("__").join("/"));

  Widget build({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = false,
    bool reverse = false,
    bool animate = true,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Lottie.asset(
        path,
        fit: fit,
        animate: animate,
        repeat: repeat,
        reverse: reverse,
      ),
    );
  }

  Future<ByteData> get byteData => rootBundle.load(path);
}
