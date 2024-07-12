import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/functional/PurchaseHandler.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';
import 'package:photogenerator/utils/Api.dart';
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
    blocManager.initializeAllBlocs();
    blocManager.adsBloc.loadAd();

    try {
      await Future.wait([
        CustomImages.precacheImages(context),
        Api.setInfo(),
        blocManager.userBloc.initializeUserId(),
        blocManager.galleryBloc.initializeData(),
        PurchaseHandler.initialize(),
      ], eagerError: true);
    } catch (e) {
      if (kDebugMode) print(e);
      if (e is Error) print(e.stackTrace);
      return Common.showSnackbar();
    }

    PurchaseHandler.subscribeToPurchaseUpdates();

    try {
      await Future.wait([
        blocManager.userBloc.refresh(
          maxCredits: Api.maxCredits,
          creditGainPeriod: Api.creditGainPeriod,
        ),
        blocManager.generationBloc.refresh(blocManager.userBloc.userId!),
        blocManager.modelBloc.refresh(),
        PurchaseHandler.validatePastTransactions(),
        PurchaseHandler.getProductsDetails(),
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
