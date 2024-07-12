import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/models/offer.dart';
import 'package:photogenerator/ui/widgets/grey_out_container.dart';
import 'package:photogenerator/ui/widgets/random_shimmer.dart';
import 'package:super_banners/super_banners.dart';

// ignore: must_be_immutable
class OfferPreview extends StatelessWidget {
  late AppThemeV2 _appTheme;

  OfferPreview({
    Key? key,
    required this.offer,
    required this.adsOffer,
    required this.inactive,
    required this.smallDisplay,
    required this.onTap,
  }) : super(key: key);

  final Offer offer;
  final bool adsOffer;
  final bool inactive;
  final bool smallDisplay;
  final void Function() onTap;

  Widget _buildOfferImage(CustomPngs illustration) {
    return RandomShimmer(
      child: Container(
        width: !smallDisplay ? 122.sp : 85.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(width: 2.sp, color: Colors.white),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: illustration.build(
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildCreditOfferText({
    required String creditText,
    required String additionalText,
    required bool big,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          creditText,
          style: big
              ? _appTheme.fonts.title.black.style
              : _appTheme.fonts.sTitle.black.style,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: big ? 4.sp : 3.sp),
          child: Text(
            additionalText,
            style: big
                ? _appTheme.fonts.sBody.semibold.style
                : _appTheme.fonts.sBody.semibold.style,
          ),
        ),
      ],
    );
  }

  Widget _buildPaidOfferButton() {
    return RandomShimmer(
      child: Container(
        width: 90.sp,
        padding: EdgeInsets.symmetric(
          vertical: 3.sp,
          horizontal: 5.sp,
        ),
        decoration: BoxDecoration(
          gradient: _appTheme.palette.primaryGradient,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(
            width: 1.sp,
            color: _appTheme.palette.textColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: !smallDisplay ? 20.sp : 18.sp,
              color: _appTheme.palette.textColor,
            ),
            Padding(padding: EdgeInsets.only(left: 5.sp)),
            Text(
              "${offer.price.toStringAsFixed(0)}€",
              style: !smallDisplay
                  ? _appTheme.fonts.title.bold.style
                  : _appTheme.fonts.body.bold.style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsOfferButton() {
    return RandomShimmer(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.sp,
          horizontal: 5.sp,
        ),
        decoration: BoxDecoration(
          gradient: _appTheme.palette.primaryGradient,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(
            width: 1.sp,
            color: _appTheme.palette.textColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.live_tv_rounded,
              size: 20.sp,
              color: _appTheme.palette.textColor,
            ),
            Padding(padding: EdgeInsets.only(left: 5.sp)),
            Text(
              "VISIONNER UNE PUB",
              style: _appTheme.fonts.xsBody.semibold.style,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppThemeV2.of(context);

    return GreyOutContainer(
      active: inactive,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  gradient: _appTheme.palette.primaryGradient,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildOfferImage(offer.illustration),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (smallDisplay)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _buildCreditOfferText(
                                      creditText: offer.credits.toString(),
                                      additionalText:
                                          " CRÉDIT${offer.credits > 1 ? "S" : ""}",
                                      big: true,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 5.sp)),
                                    if (offer.bonus > 0)
                                      _buildCreditOfferText(
                                        creditText:
                                            "+" + offer.bonus.toString(),
                                        additionalText: "",
                                        big: false,
                                      ),
                                    if (adsOffer)
                                      _buildCreditOfferText(
                                        creditText: "GRATUIT",
                                        additionalText: "",
                                        big: false,
                                      ),
                                  ],
                                ),
                              if (!smallDisplay) ...[
                                _buildCreditOfferText(
                                  creditText: offer.credits.toString(),
                                  additionalText:
                                      " CRÉDIT${offer.credits > 1 ? "S" : ""}",
                                  big: true,
                                ),
                                if (offer.bonus > 0)
                                  _buildCreditOfferText(
                                    creditText: "+" + offer.bonus.toString(),
                                    additionalText:
                                        " CRÉDIT${offer.credits > 1 ? "S" : ""}",
                                    big: false,
                                  ),
                                if (adsOffer)
                                  _buildCreditOfferText(
                                    creditText: "GRATUIT",
                                    additionalText: "",
                                    big: false,
                                  ),
                              ],
                              Padding(padding: EdgeInsets.only(top: 5.sp)),
                              adsOffer
                                  ? _buildAdsOfferButton()
                                  : _buildPaidOfferButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (offer.hasBanner)
                Align(
                  alignment: Alignment.topRight,
                  child: CornerBanner(
                    bannerPosition: CornerBannerPosition.topRight,
                    bannerColor: offer.bannerColor!,
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.sp, bottom: 2.sp),
                      child: Text(
                        offer.bannerText!,
                        style: _appTheme.fonts.xxsBody.semibold.noHeight.style,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
