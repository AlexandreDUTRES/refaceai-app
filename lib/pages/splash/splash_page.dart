import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/splash/splash_page_bloc.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';

// ignore: must_be_immutable
class SplashPage extends StatelessWidget {
  late SplashPageBloc bloc;
  late AppThemeV2 _appTheme;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<SplashPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      removeTopBannerPadding: true,
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        Future.delayed(Duration.zero)
            .then((_) async => await bloc.afterFirstBuild(context));

        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
          child: LayoutBuilder(
            builder: (_, constraints) => Stack(
              children: [
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: CustomPngs.others__splash_background
                      .build(fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomPngs.logo__logo_shadowed.build(
                    width: 150.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
