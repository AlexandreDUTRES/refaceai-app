import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/main.dart';

class AdsHandler {
  static bool _isLoading = false;
  static RewardedAd? _rewardedAd;

  static Future<void> dispose() async {
    await _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoading = false;
  }

  static Future<RewardedAd?> getRewardedAd() async {
    while (_isLoading) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (_rewardedAd != null) return _rewardedAd;
    _isLoading = true;

    Completer<RewardedAd?> completer = Completer<RewardedAd?>();

    await RewardedAd.load(
      adUnitId: Globals.adMobAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) print('Ad ${ad.adUnitId} loaded.');
          completer.complete(ad);
        },
        onAdFailedToLoad: (LoadAdError error) async {
          if (kDebugMode) print('RewardedAd failed to load: $error');
          completer.complete(null);
        },
      ),
    );
    _rewardedAd = await completer.future;
    _isLoading = false;

    return _rewardedAd;
  }

  static Future<void> showAd({
    required RewardedAd ad,
    required String advertId,
  }) async {
    await ad.setServerSideOptions(
      ServerSideVerificationOptions(
        userId: blocManager.userBloc.userId,
        customData: advertId,
      ),
    );

    Completer<void> c = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: (ad, err) {
        if (!c.isCompleted) c.complete();
      },
      onAdDismissedFullScreenContent: (ad) {
        if (!c.isCompleted) c.complete();
      },
    );
    await ad.show(
      onUserEarnedReward: (ad, rewardItem) {
        if (kDebugMode) print("Ad success");
      },
    );

    await c.future;

    await dispose();
    getRewardedAd();
  }
}
