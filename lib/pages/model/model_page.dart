import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/pages/model/model_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/bloc_manager/generations_builder.dart';
import 'package:photogenerator/ui/widgets/dynamic_network_images.dart';
import 'package:photogenerator/ui/widgets/measure_size_render_object.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:photogenerator/ui/widgets/random_shimmer.dart';
import 'package:photogenerator/ui/widgets/static_grid.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:styled_widget/styled_widget.dart';

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
              if (model.type == ModelType.premium_ad)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildModelPremiumAdBadge().padding(bottom: 25.sp),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(Model model) {
    IconData icon;
    String text;
    Future<void> Function() onTap;

    if (model.type == ModelType.premium_ad && !model.owned) {
      icon = Icons.lock_open_outlined;
      text = tr("pages.model.btn_unlock_model");
      onTap = bloc.unlockPremiumAdModel;
    } else {
      icon = Icons.photo_library_outlined;
      text = tr("pages.model.btn_select_photo");
      onTap = bloc.openGalleryPage;
    }

    return MeasureSize(
      onChange: (Size s) => bloc.setPhotoButtonHeight(s.height),
      child: GestureDetector(
        onTap: onTap,
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
                icon,
                size: 25.sp,
                color: _appTheme.palette.textColor,
              ),
              Padding(padding: EdgeInsets.only(left: 8.sp)),
              Text(
                text,
                style: _appTheme.fonts.xsTitle.bold.style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenerationContainer({
    required double size,
    required Generation generation,
    required List<Generation> generations,
  }) {
    return GestureDetector(
      onTap: () async => await Common.goToGenerationPage(
        generation: generation,
        generations: generations,
      ),
      child: Container(
        height: size,
        width: size,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: _appTheme.palette.secondaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: CachedNetworkImage(
          imageUrl: generation.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGenerationsList(List<Generation> generations) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 25.sp)),
          Text(
            tr("pages.model.title_collection"),
            style: _appTheme.fonts.xsTitle.bold.style,
          ).padding(horizontal: 16.sp, bottom: 10.sp),
          StaticGrid(
            columnCount: 3,
            verticalGap: 8.sp,
            horizontalGap: 8.sp,
            children: generations
                .map(
                  (generation) => LayoutBuilder(
                    builder: (_, constraints) => _buildGenerationContainer(
                      size: constraints.maxWidth,
                      generation: generation,
                      generations: generations,
                    ),
                  ),
                )
                .toList(),
          ).padding(horizontal: 16.sp),
        ],
      ),
    );
  }

  Widget _buildEmptyGenerationContainer() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          CustomLotties.animated__ghost.build(height: 200.sp, repeat: true),
          Text(
            tr("pages.model.txt_empty_collection_1"),
            style: _appTheme.fonts.sBody.style,
            textAlign: TextAlign.center,
          ).padding(horizontal: 16.sp, bottom: 3.sp),
          Text(
            tr("pages.model.txt_empty_collection_2"),
            style: _appTheme.fonts.xsBody.style.copyWith(fontSize: 10.sp),
            textAlign: TextAlign.center,
          ).opacity(0.6).padding(horizontal: 16.sp),
        ],
      ),
    );
  }

  Widget _buildModelPremiumAdBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.auto_awesome,
          color: Colors.white,
          size: 15.sp,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ).padding(right: 4.sp),
        Text(
          tr("globals.premium"),
          style: _appTheme.fonts.xsBody.bold.style.copyWith(
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ],
          ),
        ).padding(bottom: 1.5.sp),
      ],
    )
        .padding(
          horizontal: 8.sp,
          vertical: 4.sp,
          right: 10.sp,
        )
        .decorated(
          color: Color(0xFFFFD700).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(50.sp),
        );
  }

  Widget _buildModelPage(BoxConstraints constraints, Model model) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildModelImage(model),
                GenerationsBuilder(
                  (generations) => generations.isEmpty
                      ? _buildEmptyGenerationContainer()
                      : _buildGenerationsList(generations),
                  promptId: model.id,
                ),
                StreamBuilder<ModelPageData>(
                  stream: bloc.stream,
                  builder: (_, snapshot) => SizedBox(
                    height: snapshot.data?.photoButtonHeight ?? 0,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 15.sp)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildMainButton(model).padding(bottom: 15.sp),
          ),
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
        Future.delayed(Duration.zero)
            .then((_) async => await bloc.afterFirstBuild());

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
