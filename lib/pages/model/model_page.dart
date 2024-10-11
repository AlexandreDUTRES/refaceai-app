import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/pages/model/model_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/widgets/dynamic_network_images.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:photogenerator/ui/widgets/random_shimmer.dart';
import 'package:preload_page_view/preload_page_view.dart';

// ignore: must_be_immutable
class ModelPage extends StatelessWidget {
  late ModelPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildModelImage(Model model) {
    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              RandomShimmer(
                noStartDelayed: true,
                child: DynamicNetworkImages(
                  urls: model.randomImages,
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  animate: true,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: SizerHandler.statusBarHeight),
                  child: PageTopBar(
                    backButton: true,
                    title: model.name(
                        getGlobalLocale(GlobalNavigator().currentContext)),
                  ),
                ),
              ),
              Container(
                height: constraints.maxWidth / 3.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText({
    required String title,
    required String description,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.sp),
      child: Row(
        children: [
          Container(
            width: 45.sp,
            height: 45.sp,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              iconData,
              size: 25.sp,
              color: _appTheme.palette.textColor,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 15.sp)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _appTheme.fonts.sBody.noHeight.semibold.style,
                ),
                Padding(padding: EdgeInsets.only(top: 6.sp)),
                Text(
                  description,
                  style: _appTheme.fonts.xsBody.style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoButton() {
    return GestureDetector(
      onTap: () async => await bloc.openGalleryPage(),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 25.sp,
              color: _appTheme.palette.textColor,
            ),
            Padding(padding: EdgeInsets.only(left: 8.sp)),
            Text(
              tr("pages.model.btn_select_photo"),
              style: _appTheme.fonts.xsTitle.bold.style,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelPage(BoxConstraints constraints, Model model) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Column(
        children: [
          _buildModelImage(model),
          Padding(padding: EdgeInsets.only(top: 25.sp)),
          _buildInfoText(
            title: tr("pages.model.txt_info_1_title"),
            description: tr("pages.model.txt_info_1_description"),
            iconData: Icons.check,
            iconColor: Colors.blue[800]!,
          ),
          Padding(padding: EdgeInsets.only(top: 20.sp)),
          _buildInfoText(
            title: tr("pages.model.txt_info_2_title"),
            description: tr("pages.model.txt_info_2_description"),
            iconData: Icons.close,
            iconColor: Colors.red[800]!,
          ),
          Expanded(child: Container()),
          _buildPhotoButton(),
          Padding(padding: EdgeInsets.only(top: 15.sp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ModelPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
      removeTopBannerPadding: true,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return Padding(
          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
          child: PreloadPageView.builder(
            controller: bloc.preloadPageController,
            itemCount: bloc.models.length,
            preloadPagesCount: min(3, bloc.models.length),
            itemBuilder: (context, i) {
              return _buildModelPage(constraints, bloc.models[i]);
            },
            onPageChanged: (i) => bloc.setIndex(i),
          ),
        );
      },
    );
  }
}
