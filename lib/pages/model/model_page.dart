import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
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
                child: PageTopBar(
                  backButton: true,
                  title: model.name(Locale("fr")),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: ElevatedButton(
          onPressed: () async => await bloc.openGalleryPage(),
          style: _appTheme.buttons.mainElevated.style,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 20.sp,
                  color: _appTheme.palette.textColor,
                ),
                Padding(padding: EdgeInsets.only(left: 8.sp)),
                Text("Choisir une photo"),
              ],
            ),
          ),
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
          Padding(
            padding: EdgeInsets.only(top: SizerHandler.statusBarHeight),
          ),
          _buildModelImage(model),
          Padding(padding: EdgeInsets.only(top: 25.sp)),
          _buildInfoText(
            title: "Sélectionnez une seule photo de vous",
            description:
                "Votre visage doit être bien visible, neutre, assez grand, bien éclairé et centré.",
            iconData: Icons.check,
            iconColor: Colors.blue[800]!,
          ),
          Padding(padding: EdgeInsets.only(top: 20.sp)),
          _buildInfoText(
            title: "Évitez les choses suivantes",
            description:
                "Pas de photo de groupe, pas de nudité, pas d'animaux, un minimum d'accessoires, pas de grimaces.",
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
      enableScroll: false,
      bodyBuilder: (BuildContext context, BoxConstraints constraints) {
        return StreamBuilder<ModelPageData>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return PreloadPageView.builder(
              controller: bloc.preloadPageController,
              itemCount: bloc.models.length,
              preloadPagesCount: min(3, bloc.models.length),
              itemBuilder: (context, i) {
                return _buildModelPage(constraints, bloc.models[i]);
              },
              onPageChanged: (i) => bloc.setIndex(i),
            );           
          },
        );
      },
    );
  }
}
