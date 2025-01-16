import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photogenerator/Globals.dart';

class AdsHandler {
  // static bool _isLoadingInterstitial = false;
  // static InterstitialAd? _interstitialAd;
  static bool _isLoadingRewarded = false;
  static RewardedAd? _rewardedAd;

  static Future<void> dispose() async {
    await _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoadingRewarded = false;
  }

  static Future<RewardedAd?> getRewardedAd() async {
    while (_isLoadingRewarded) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (_rewardedAd != null) return _rewardedAd;
    _isLoadingRewarded = true;

    Completer<RewardedAd?> completer = Completer<RewardedAd?>();

    await RewardedAd.load(
      adUnitId: Globals.adMobAdUnitIdRewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) print('RewardedAd ${ad.adUnitId} loaded.');
          completer.complete(ad);
        },
        onAdFailedToLoad: (LoadAdError error) async {
          if (kDebugMode) print('RewardedAd failed to load: $error');
          completer.complete(null);
        },
      ),
    );
    _rewardedAd = await completer.future;
    _isLoadingRewarded = false;

    return _rewardedAd;
  }

  static Future<void> showAd(
    RewardedAd rewardedAd, {
    String? userId,
    String? customData,
    Function()? onReward,
  }) async {
    await rewardedAd.setServerSideOptions(
      ServerSideVerificationOptions(
        userId: userId,
        customData: customData,
      ),
    );

    Completer<void> c = Completer<void>();
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: (ad, err) {
        if (!c.isCompleted) c.complete();
      },
      onAdDismissedFullScreenContent: (ad) {
        if (!c.isCompleted) c.complete();
      },
    );
    await rewardedAd.show(
      onUserEarnedReward: (ad, rewardItem) {
        if (kDebugMode) print("Ad success");
        if (onReward != null) onReward();
      },
    );

    await c.future;

    await dispose();
    getRewardedAd();
  }
}
