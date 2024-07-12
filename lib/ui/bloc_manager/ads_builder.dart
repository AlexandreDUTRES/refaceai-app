import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/ads_bloc_data.dart';

class AdsBuilder extends StatelessWidget {
  final Widget Function(RewardedAd?) builder;
  final Widget? placeHolder;

  AdsBuilder(this.builder, {this.placeHolder});

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AdsBlocData>(
      stream: blocManager.adsBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _placeHolder;
        return builder(snapshot.data!.rewardedAd);
      },
    );
  }
}
