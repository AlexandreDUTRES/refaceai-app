import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/loading/loading_page_bloc.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';

// ignore: must_be_immutable
class LoadingPage extends StatelessWidget {
  late LoadingPageBloc bloc;
  late AppThemeV2 _appTheme;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoadingPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
      canPop: false,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return StreamBuilder<LoadingPageData>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: topPadding)),
                CustomLotties.animated__loader.build(
                  width: 250.sp,
                  repeat: true,
                ),
                AnimatedOpacity(
                  opacity: snapshot.data!.opacity,
                  duration: bloc.fadeDuration,
                  child: Container(
                    width: 0.9.sw,
                    child: Text(
                      bloc.loadingSentences[snapshot.data!.sentenceIndex],
                      style: _appTheme.fonts.body.semibold.style,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: bottomPadding + 30.sp)),
              ],
            );
          },
        );
      },
    );
  }
}
