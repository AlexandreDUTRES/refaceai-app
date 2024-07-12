import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/ads_bloc_data.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:uuid/uuid.dart';

class AdsBloc extends BlocRx<AdsBlocData> {
  AdsBloc() {
    initialize(AdsBlocData());
  }

  RewardedAd? get rewardedAd => blocData!.rewardedAd;

  Future<void> resetData() async {
    if (blocData!.rewardedAd != null) {
      await blocData!.rewardedAd!.dispose();
      blocData!.rewardedAd = null;
    }
    updateUI();
  }

  Future<void> loadAd() async {
    await RewardedAd.load(
      adUnitId: Globals.adMobAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) print('Ad ${ad.adUnitId} loaded.');
          blocData!.rewardedAd = ad;
          updateUI();
        },
        onAdFailedToLoad: (LoadAdError error) async {
          if (kDebugMode) print('RewardedAd failed to load: $error');
          await Future.delayed(Duration(seconds: 5));
          await loadAd();
        },
      ),
    );
  }

  Future<String?> showAd() async {
    if (blocData!.rewardedAd == null) return null;

    String orderId = Uuid().v4();
    await blocData!.rewardedAd!.setServerSideOptions(
      ServerSideVerificationOptions(
        userId: blocManager.userBloc.userId,
        customData: orderId,
      ),
    );

    Completer<bool> c = Completer<bool>();
    blocData!.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: (ad, err) {
        if (!c.isCompleted) c.complete(false);
      },
      onAdDismissedFullScreenContent: (ad) {
        if (!c.isCompleted) c.complete(false);
      },
    );
    await blocData!.rewardedAd!.show(
      onUserEarnedReward: (ad, rewardItem) {
        if (!c.isCompleted) c.complete(true);
      },
    );

    bool res = await c.future;

    await resetData();
    loadAd();

    return res ? orderId : null;
  }

  Future<void> adCheckRetreiver(String orderId) async {
    bool isProcessing = false;
    int counter = 10;
    Timer.periodic(Duration(seconds: 3), (timer) async {
      if (isProcessing) return;
      isProcessing = true;
      if (kDebugMode) print("adCheckRetreiver: $orderId ($counter)");

      counter--;
      if (counter == 0) timer.cancel();

      try {
        await Api.getPurchase(orderId);
        await blocManager.userBloc.refresh(
          maxCredits: Api.maxCredits,
          creditGainPeriod: Api.creditGainPeriod,
        );
        Common.showSnackbar("Félicitations, vous avez gagné 10 crédits !");
        timer.cancel();
      } catch (e) {
        if (kDebugMode) print(e);
      }

      isProcessing = false;
    });
  }
}
