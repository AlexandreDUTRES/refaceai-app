import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/app_ui/variables.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:photogenerator/pages/home/generations/generations_page.dart';
import 'package:photogenerator/pages/home/generations/generations_page_bloc.dart';
import 'package:photogenerator/pages/home/home_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/home/models/models_page.dart';
import 'package:photogenerator/pages/home/models/models_page_bloc.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:preload_page_view/preload_page_view.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  late HomePageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildNavigationIcon({
    required String text,
    required IconData iconData,
    required bool isActive,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 6.sp)),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Icon(
                  iconData,
                  size: min(constraints.maxHeight, constraints.maxWidth),
                  color: isActive
                      ? _appTheme.palette.primaryColor
                      : _appTheme.palette.secondaryColor,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 4.sp)),
            Text(
              text,
              style: TextStyle(
                color: isActive
                    ? _appTheme.palette.primaryColor
                    : _appTheme.palette.secondaryColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 10.sp,
                height: 18 / 10,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 2.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(AsyncSnapshot<HomePageData> snapshot) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 10),
        child: Container(
          width: 1.sw,
          height: NAVIGATION_BAR_HEIGHT,
          padding: EdgeInsets.only(top: 4.sp, bottom: 3.sp),
          decoration: BoxDecoration(
            color: _appTheme.palette.borderColor,
            border: Border(
              top: BorderSide(
                color: _appTheme.palette.borderColor.withOpacity(0.8),
                width: 1.sp,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildNavigationIcon(
                        text: tr("pages.home.btn_nav_model"),
                        iconData: Icons.face_retouching_natural_outlined,
                        isActive: snapshot.data!.navigationState ==
                            HomeNavigationState.models,
                        onTap: () => bloc
                            .goToNavigationState(HomeNavigationState.models),
                      ),
                    ),
                    Expanded(
                      child: _buildNavigationIcon(
                        text: tr("pages.home.btn_nav_images"),
                        iconData: Icons.photo_library_outlined,
                        isActive: snapshot.data!.navigationState ==
                            HomeNavigationState.generations,
                        onTap: () => bloc.goToNavigationState(
                            HomeNavigationState.generations),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HomePageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    final BlocProvider<ModelsPageBloc> modelsProvider =
        BlocProvider<ModelsPageBloc>(
      bloc: ModelsPageBloc(),
      child: ModelsPage(),
    );

    final BlocProvider<GenerationsPageBloc> generationsProvider =
        BlocProvider<GenerationsPageBloc>(
      bloc: GenerationsPageBloc(),
      child: GenerationsPage(),
    );

    return StreamBuilder<HomePageData>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return PageLayout(
          backgroundColor: _appTheme.palette.backgroundColor,
          canPop: bloc.canPop,
          onPopInvoked: bloc.onPopInvoked,
          bottomStickyWidget: _buildNavBar(snapshot),
          bodyBuilder: (
            BuildContext context,
            BoxConstraints constraints,
            double topPadding,
            double bottomPadding,
          ) {
            Future.delayed(Duration.zero).then((_) => bloc.afterFirstBuild());
            return Padding(
              padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
              child: PreloadPageView.builder(
                controller: bloc.preloadPageController,
                itemCount: HomeNavigationState.values.length,
                preloadPagesCount: HomeNavigationState.values.length,
                itemBuilder: (context, i) {
                  HomeNavigationState state = HomeNavigationState.values[i];
                  switch (state) {
                    case HomeNavigationState.models:
                      return modelsProvider;
                    case HomeNavigationState.generations:
                      return generationsProvider;
                  }
                },
                onPageChanged: (i) =>
                    bloc.setNavigationState(HomeNavigationState.values[i]),
              ),
            );
          },
        );
      },
    );
  }
}
