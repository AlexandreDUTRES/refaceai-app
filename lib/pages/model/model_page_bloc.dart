import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/functional/AdsHandler.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

class ModelPageData {}

class ModelPageBloc extends Bloc<ModelPageData> {
  late int _index;
  late List<Model> _models;

  late PreloadPageController preloadPageController;

  ModelPageBloc(Map<String, dynamic> args) : super(ModelPageData()) {
    assert(args.containsKey("index") && args["index"] is int);
    _index = args["index"];

    assert(args.containsKey("models") && args["models"] is List<Model>);
    _models = args["models"];

    preloadPageController = PreloadPageController(initialPage: _index);
  }

  List<Model> get models => _models;

  void setIndex(int v) {
    _index = v;
  }

  Future<void> openGalleryPage() async {
    Completer<String?> c = Completer<String?>();
    await GlobalNavigator().navigate(
      "/GalleryPage",
      callback: (res) {
        if (c.isCompleted) return;
        if (res != null && res.containsKey("filePath")) {
          return c.complete(res["filePath"]);
        }
        return c.complete(null);
      },
    );
    String? filePath = await c.future;
    if (filePath == null) return;

    await _generate(filePath);
  }

  Future<void> _generate(String filePath) async {
    await GlobalLoader.showOverlayLoader();
    final String advertStatus = await Api.getUserGenerationStatus(
      blocManager.userBloc.userId!,
    );
    GlobalLoader.hideOverlayLoader();

    InterstitialAd? interstitialAd;
    RewardedAd? rewardedAd;

    if (advertStatus == 'no_ad') {
      await GlobalLoader.showLoadingPage();
    } else if (advertStatus == 'long_ad' || advertStatus == 'short_ad') {
      if (!SharedPreferencesStorage.getAdWarning()) {
        await _showAdWarningPage();
      }

      await GlobalLoader.showLoadingPage();
      // get google ads rewarded ad
      if (advertStatus == 'long_ad') {
        rewardedAd = await AdsHandler.getRewardedAd();
      } else {
        print("SHORT AD");
        interstitialAd = await AdsHandler.getInterstitialAd();
      }
      if (rewardedAd == null && interstitialAd == null) {
        await GlobalLoader.hideLoadingPage();
        return Common.showSnackbar(tr("pages.model.snackbar_no_ad"));
      }
    } else {
      return;
    }

    try {
     final List<dynamic> res = await Future.wait([
        Api.startGeneration(
          blocManager.userBloc.userId!,
          filePath: filePath,
          promptId: _models[_index].id,
          advertStatus: advertStatus,
        ),
        if (rewardedAd != null || interstitialAd != null)
          AdsHandler.showAd(
            rewardedAd: rewardedAd,
            interstitialAd: interstitialAd,
          ),
      ]);

      Generation generation = await _waitGeneration(res[0] as String);
      await GlobalLoader.hideLoadingPage();
      Provider.of<GlobalAppData>(
        GlobalNavigator().currentContext,
        listen: false,
      ).updateHomeNavigationState(HomeNavigationState.generations);
      await GlobalNavigator().popWithRemoval();
      await Common.goToGenerationPage(generation);
    } catch (e) {
      await GlobalLoader.hideLoadingPage();
      if (e is Error) print(e.stackTrace);
      Common.showSnackbar();
      rethrow;
    }
  }

  Future<Generation> _waitGeneration(String generationId) async {
    final int maxRetry = 90;
    int cnt = 0;

    while (cnt < maxRetry) {
      try {
        return await blocManager.generationBloc
            .retreiveGenerationById(generationId);
      } catch (e) {
        if (kDebugMode) print(e);
      }
      await Future.delayed(Duration(seconds: 1));
      cnt++;
    }

    throw "No generation found";
  }

  static Future<void> _showAdWarningPage() async {
    Completer<void> c = Completer<void>();
    await GlobalNavigator().navigate(
      "/AdWarningPage",
      callback: (res) async {
        if (c.isCompleted) return;
        c.complete();
      },
    );
    await c.future;
    await SharedPreferencesStorage.storeAdWarning(true);
  }
}
