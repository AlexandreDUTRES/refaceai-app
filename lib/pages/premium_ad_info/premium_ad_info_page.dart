import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/premium_ad_info/premium_ad_info_page_bloc.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ignore: must_be_immutable
class PremiumAdInfoPage extends StatelessWidget {
  late PremiumAdInfoPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: CustomLotties.animated__ad.build(
        width: 200.sp,
      ),
    );
  }

  Widget _buildTitleText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      child: Animate(
        effects: [FadeEffect()],
        child: Text(
          tr("pages.premium_ad_info_page.txt_title"),
          style: _appTheme.fonts.sTitle.bold.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Container(
      width: 280.sp,
      child: Text(
        tr("pages.premium_ad_info_page.txt_info"),
        style: _appTheme.fonts.sBody.smallHeight.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () async => await bloc.confirm(),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.sp),
        padding: EdgeInsets.symmetric(
          vertical: 15.sp,
          horizontal: 50.sp,
        ),
        decoration: BoxDecoration(
          gradient: _appTheme.palette.primaryGradient,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Text(
          tr("pages.premium_ad_info_page.btn_confirm"),
          style: _appTheme.fonts.sTitle.bold.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PremiumAdInfoPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return Column(
          children: [
            Padding(padding: EdgeInsets.only(top: topPadding)),
            Expanded(child: Container()),
            _buildImage(),
            Padding(padding: EdgeInsets.only(top: 40.sp)),
            _buildTitleText(),
            Padding(padding: EdgeInsets.only(top: 15.sp)),
            _buildDescriptionText(),
            Expanded(child: Container()),
            _buildButton(),
            Padding(padding: EdgeInsets.only(top: bottomPadding + 15.sp)),
          ],
        );
      },
    );
  }
}
