import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photogenerator/Globals.dart';

class AdsHandler {
  static bool _isLoadingInterstitial = false;
  static InterstitialAd? _interstitialAd;
  static bool _isLoadingRewarded = false;
  static RewardedAd? _rewardedAd;

  static Future<void> dispose() async {
    await _interstitialAd?.dispose();
    await _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
    _isLoadingInterstitial = false;
    _isLoadingRewarded = false;
  }

  static Future<InterstitialAd?> getInterstitialAd() async {
    while (_isLoadingInterstitial) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    if (_interstitialAd != null) return _interstitialAd;
    _isLoadingInterstitial = true;

    Completer<InterstitialAd?> completer = Completer<InterstitialAd?>();

    await InterstitialAd.load(
      adUnitId: Globals.adMobAdUnitIdInterstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) print('InterstitialAd ${ad.adUnitId} loaded.');
          completer.complete(ad);
        },
        onAdFailedToLoad: (LoadAdError error) async {
          if (kDebugMode) print('InterstitialAd failed to load: $error');
          completer.complete(null);
        },
      ),
    );
    _interstitialAd = await completer.future;
    _isLoadingInterstitial = false;

    return _interstitialAd;
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

  static Future<void> showAd({
    required RewardedAd? rewardedAd,
    required InterstitialAd? interstitialAd,
  }) async {
    assert(rewardedAd != null || interstitialAd != null);
    // print(blocManager.userBloc.userId);
    // print(advertId);
    // await ad.setServerSideOptions(
    //   ServerSideVerificationOptions(
    //     userId: blocManager.userBloc.userId,
    //     customData: advertId,
    //   ),
    // );

    Completer<void> c = Completer<void>();
    if (rewardedAd != null) {
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
        },
      );
    }

    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (ad, err) {
          if (!c.isCompleted) c.complete();
        },
        onAdDismissedFullScreenContent: (ad) {
          if (!c.isCompleted) c.complete();
        },
      );
      await interstitialAd.show();
    }

    await c.future;

    await dispose();
    getRewardedAd();
  }
}
