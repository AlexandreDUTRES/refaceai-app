import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/functional/AdsHandler.dart';
import 'package:photogenerator/functional/FcmHandler.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:photogenerator/utils/OnboardingTools.dart';

class SplashPageData {}

class SplashPageBloc extends Bloc<SplashPageData> {
  SplashPageBloc() : super(SplashPageData());

  Future<void> afterFirstBuild(BuildContext context) async {
    await super.singleExecutionTask("after_build", () async {
      await _compute(context);
    });
  }

  Future<void> _compute(BuildContext context) async {
    AdsHandler.getRewardedAd();
    blocManager.initializeAllBlocs();

    try {
      await Future.wait([
        FcmHandler.requestNotificationPermission(),
        CustomImages.precacheImages(context),
        blocManager.userBloc.initializeUserId(),
        blocManager.galleryBloc.initializeData(),
      ], eagerError: true);
    } catch (e) {
      if (kDebugMode) print(e);
      if (e is Error) print(e.stackTrace);
      return Common.showSnackbar();
    }

    try {
      await Future.wait([
        blocManager.generationBloc.refresh(blocManager.userBloc.userId!),
        blocManager.modelBloc.refresh(),
      ], eagerError: true);
    } catch (e) {
      if (kDebugMode) print(e);
      return Common.showSnackbar();
    }

    if (!SharedPreferencesStorage.getOnboardingTour()) {
      await OnboardingTools.startTour();
      await SharedPreferencesStorage.storeOnboardingTour(true);
    }
    await GlobalNavigator().navigate("/HomePage");
  }
}
