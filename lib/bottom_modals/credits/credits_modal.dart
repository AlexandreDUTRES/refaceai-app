import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/bottom_modals/credits/credits_modal_bloc.dart';
import 'package:photogenerator/constants/Offers.dart';
import 'package:photogenerator/models/offer.dart';
import 'package:photogenerator/ui/bloc_manager/ads_builder.dart';
import 'package:photogenerator/ui/widgets/bottom_modal_layout.dart';
import 'package:photogenerator/ui/widgets/offer_preview.dart';

// responsive ok
// ignore: must_be_immutable
class CreditsModal extends StatelessWidget {
  late CreditsModalBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildInfoText() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Text(
        "Vous n'avez plus suffisamment de crédits pour générer une image.",
        style: _appTheme.fonts.sBody.semibold.style,
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
        smallDisplay: true,
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
      smallDisplay: true,
      onTap: productDetails == null
          ? () => bloc.showMissingGoogleAccount()
          : () async => await bloc.buyProduct(productDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreditsModalBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return BottomModalLayout(
      backgroundColor: _appTheme.palette.borderColor,
      content: StreamBuilder<CreditsModalData>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: EdgeInsets.only(top: 16.sp)),
              _buildInfoText(),
              Padding(padding: EdgeInsets.only(top: 24.sp)),
              _buildAdsOfferContainer(),
              Padding(padding: EdgeInsets.only(top: 8.sp)),
              _buildChargedOfferContainer(
                offer: Offers.chargedOffers[0],
                productDetails: snapshot.data!
                    .productDetailsById(Offers.chargedOffers[0].id),
              ),
              Padding(padding: EdgeInsets.only(top: 8.sp)),
              _buildChargedOfferContainer(
                offer: Offers.chargedOffers[1],
                productDetails: snapshot.data!
                    .productDetailsById(Offers.chargedOffers[1].id),
              ),
              Padding(padding: EdgeInsets.only(top: 8.sp)),
              _buildChargedOfferContainer(
                offer: Offers.chargedOffers[2],
                productDetails: snapshot.data!
                    .productDetailsById(Offers.chargedOffers[2].id),
              ),
              Padding(padding: EdgeInsets.only(top: 16.sp)),
            ],
          );
        },
      ),
    );
  }
}
