import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/pages/onboarding/onboarding_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/random_shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ignore: must_be_immutable
class OnboardingPage extends StatelessWidget {
  late OnboardingPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Center(
        child: ZoomIn(
          child: RandomShimmer(
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: bloc.image.build(),
            ),
          ),
        ),
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
          bloc.title,
          style: _appTheme.fonts.sTitle.bold.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      child: Animate(
        effects: [FadeEffect()],
        child: Text(
          bloc.description,
          style: _appTheme.fonts.body.smallHeight.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSubBtnText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      child: Text(
        bloc.subBtnText!,
        style: _appTheme.fonts.xxsBody.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () async => await bloc.goNext(),
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
          bloc.btnText,
          style: _appTheme.fonts.sTitle.bold.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<OnboardingPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return StreamBuilder<OnboardingPageData>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return Column(
              children: [
                Padding(padding: EdgeInsets.only(top: topPadding)),
                Expanded(child: _buildImage()),
                _buildTitleText(),
                Padding(padding: EdgeInsets.only(top: 4.sp)),
                _buildDescriptionText(),
                Padding(padding: EdgeInsets.only(top: 30.sp)),
                _buildButton(),
                if (bloc.subBtnText != null) ...[
                  Padding(padding: EdgeInsets.only(top: 15.sp)),
                  _buildSubBtnText(),
                ],
                Padding(padding: EdgeInsets.only(top: bottomPadding + 15.sp)),
              ],
            );
          },
        );
      },
    );
  }
}
