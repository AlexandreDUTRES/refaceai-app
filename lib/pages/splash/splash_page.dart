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
      
      backgroundGradient: _appTheme.palette.primaryGradient,
      bodyBuilder: (BuildContext context, BoxConstraints constraints) {
        Future.delayed(Duration.zero)
            .then((_) async => await bloc.afterFirstBuild(context));

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvgs.logo__logo.build(
              size: 120.sp,
              color: _appTheme.palette.textColor,
            ),
          ],
        );
      },
    );
  }
}
