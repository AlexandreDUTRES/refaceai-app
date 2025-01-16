import 'dart:async';
import 'dart:convert';

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

class ModelPageData {
  double? photoButtonHeight;
}

class ModelPageBloc extends Bloc<ModelPageData> {
  int _index;
  final List<Model> _models;
  final bool _directUse;

  late PreloadPageController preloadPageController;

  ModelPageBloc(Map<String, dynamic> args)
      : _index = args["index"] as int,
        _models = args["models"] as List<Model>,
        _directUse = args["directUse"] as bool,
        super(ModelPageData()) {
    preloadPageController = PreloadPageController(initialPage: _index);
  }

  List<Model> get models => _models;

  Future<void> afterFirstBuild() async {
    await super.singleExecutionTask("after_build", () async {
      if (_directUse && _models[_index].owned) await openGalleryPage();
    });
  }

  void setIndex(int v) {
    _index = v;
  }

  void setPhotoButtonHeight(double v) {
    blocData.photoButtonHeight = v;
    updateUI();
  }

  Future<void> _generate(String filePath) async {
    await GlobalLoader.showLoadingPage();
    try {
      final String generationId = await Api.startGeneration(
        blocManager.userBloc.userId!,
        filePath: filePath,
        promptId: _models[_index].id,
      );
      Generation generation = await _waitGeneration(generationId);

      await GlobalLoader.hideLoadingPage();
      Provider.of<GlobalAppData>(
        GlobalNavigator().currentContext,
        listen: false,
      ).updateHomeNavigationState(HomeNavigationState.generations);
      await GlobalNavigator().popWithRemoval();
      await Common.goToGenerationPage(
        generation: generation,
        generations: blocManager.generationBloc.blocData!.sortedGenerations,
      );
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

  Future<Model> _waitUnlockModel(String generationId) async {
    final int maxRetry = 30;
    int cnt = 0;

    while (cnt < maxRetry) {
      try {
        await blocManager.modelBloc.refreshModel(
          blocManager.userBloc.blocData!.userId,
          _models[_index].id,
        );
        Model? model = blocManager.modelBloc.blocData!.allModels
            .where(
              (m) => m.id == _models[_index].id,
            )
            .firstOrNull;
        if (model?.owned ?? false) return model!;
      } catch (e) {
        if (kDebugMode) print(e);
      }
      await Future.delayed(Duration(seconds: 1));
      cnt++;
    }

    throw "No generation found";
  }

  static Future<bool> _showPremiumAdInfoPage() async {
    Completer<bool> c = Completer<bool>();
    await GlobalNavigator().navigate(
      "/PremiumAdInfoPage",
      callback: (res) {
        if (c.isCompleted) return;
        if (res != null && res.containsKey("confirm")) {
          return c.complete(true);
        } else {
          return c.complete(false);
        }
      },
    );
    final bool res = await c.future;
    await SharedPreferencesStorage.storeAdWarning(true);
    return res;
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

  Future<void> unlockPremiumAdModel() async {
    if (!await _showPremiumAdInfoPage()) return;

    RewardedAd? rewardedAd = await AdsHandler.getRewardedAd();
    if (rewardedAd == null) {
      await GlobalLoader.hideLoadingPage();
      return Common.showSnackbar(tr("pages.model.snackbar_no_ad"));
    }

    final Completer<void> c = Completer<void>();
    await AdsHandler.showAd(
      rewardedAd,
      userId: blocManager.userBloc.userId,
      customData: Uri.encodeComponent(
        jsonEncode(
          {'type': 'unlock_premium_model', 'data': _models[_index].id},
        ),
      ),
      onReward: () async {
        if (!c.isCompleted) c.complete();
      },
    );
    await c.future;

    try {
      await GlobalLoader.showOverlayLoader();
      await _waitUnlockModel(_models[_index].id);
    } catch (e) {
      GlobalLoader.hideOverlayLoader();
      return Common.showSnackbar();
    }

    GlobalLoader.hideOverlayLoader();
    await GlobalNavigator().pop();
    await Common.goToModelPage(_models[_index]);
    Common.showSnackbar(
        'Félicitations ! Le modèle a été ajouté à votre collection');
  }
}
