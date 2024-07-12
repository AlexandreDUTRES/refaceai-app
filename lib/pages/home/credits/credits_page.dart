import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/constants/Offers.dart';
import 'package:photogenerator/models/offer.dart';
import 'package:photogenerator/pages/home/credits/credits_page_bloc.dart';
import 'package:photogenerator/ui/bloc_manager/ads_builder.dart';
import 'package:photogenerator/ui/bloc_manager/user_builder.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/widgets/main_scroller.dart';
import 'package:photogenerator/ui/widgets/offer_preview.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:photogenerator/utils/Api.dart';

// ignore: must_be_immutable
class CreditsPage extends StatelessWidget {
  late CreditsPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildCreditsContainer() {
    return UserBuilder(
      (credits, timeTillNextCredit) {
        String? timeTillNextCreditTxt;
        if (timeTillNextCredit != null) {
          if (timeTillNextCredit <= 0) {
            timeTillNextCreditTxt = "";
          } else {
            Duration duration = Duration(milliseconds: timeTillNextCredit);

            int hours = duration.inHours;
            int minutes = duration.inMinutes.remainder(60);
            if (hours == 0 && minutes == 0) minutes = 1;

            timeTillNextCreditTxt = "";
            if (hours > 0)
              timeTillNextCreditTxt += "${hours} heure${hours > 1 ? "s" : ""}";
            if (minutes > 0) {
              if (timeTillNextCreditTxt.isNotEmpty)
                timeTillNextCreditTxt += " et ";
              timeTillNextCreditTxt +=
                  "${minutes} minute${minutes > 1 ? "s" : ""}";
            }
          }
        }

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 16.sp),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.toll,
                    size: 20.sp,
                    color: _appTheme.palette.textColor,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5.sp)),
                  Flexible(
                    child: Text(
                      "${credits.count} crédit${credits.count > 1 ? "s" : ""} disponible${credits.count > 1 ? "s" : ""}",
                      style: _appTheme.fonts.body.semibold.style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 12.sp)),
              LinearProgressIndicator(
                value: (credits.count / Api.maxCredits) > 1
                    ? 1
                    : (credits.count / Api.maxCredits),
                minHeight: 5.sp,
                backgroundColor: _appTheme.palette.borderColor,
                color: _appTheme.palette.primaryColor,
                borderRadius: BorderRadius.circular(5.sp),
              ),
              if (timeTillNextCreditTxt != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.sp),
                  child: Text(
                    "Prochain crédit dans $timeTillNextCreditTxt",
                    style: _appTheme.fonts.xsBody.style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildObtainText() {
    return Container(
      width: double.infinity,
      child: Text(
        "Obtenir des crédits",
        style: _appTheme.fonts.sTitle.semibold.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCreditInfoText() {
    return Container(
      width: double.infinity,
      child: Text(
        "1 crédit = 1 image",
        style: _appTheme.fonts.sBody.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAdsOfferContainer() {
    return AdsBuilder(
      (rewardedAd) => OfferPreview(
        offer: Offers.freeOffer,
        adsOffer: true,
        inactive: rewardedAd == null,
        smallDisplay: false,
        onTap: rewardedAd == null
            ? () => bloc.showAdsUnfound()
            : () async => await bloc.showAd(),
      ),
    );
  }

  Widget _buildChargedOfferContainer({
    required Offer offer,
    required IAPItem? productDetails,
  }) {
    return OfferPreview(
      offer: offer,
      adsOffer: false,
      inactive: productDetails == null,
      smallDisplay: false,
      onTap: productDetails == null
          ? () => bloc.showMissingGoogleAccount()
          : () async => await bloc.buyProduct(productDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreditsPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return StreamBuilder<CreditsPageData>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return LayoutBuilder(
          builder: (context, constraints) => MainScroller(
            parentHeight: constraints.maxHeight,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizerHandler.statusBarHeight),
                ),
                PageTopBar(
                  backButton: false,
                  title: "Mes crédits",
                ),
                _buildCreditsContainer(),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.sp, vertical: 25.sp),
                  height: 1.sp,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.5),
                ),
                _buildObtainText(),
                _buildCreditInfoText(),
                Padding(padding: EdgeInsets.only(top: 30.sp)),
                _buildAdsOfferContainer(),
                Padding(padding: EdgeInsets.only(top: 15.sp)),
                _buildChargedOfferContainer(
                  offer: Offers.chargedOffers[0],
                  productDetails: snapshot.data!
                      .productDetailsById(Offers.chargedOffers[0].id),
                ),
                Padding(padding: EdgeInsets.only(top: 15.sp)),
                _buildChargedOfferContainer(
                  offer: Offers.chargedOffers[1],
                  productDetails: snapshot.data!
                      .productDetailsById(Offers.chargedOffers[1].id),
                ),
                Padding(padding: EdgeInsets.only(top: 15.sp)),
                _buildChargedOfferContainer(
                  offer: Offers.chargedOffers[2],
                  productDetails: snapshot.data!
                      .productDetailsById(Offers.chargedOffers[2].id),
                ),
                Padding(padding: EdgeInsets.only(top: 15.sp)),
              ],
            ),
          ),
        );
      },
    );
  }
}
