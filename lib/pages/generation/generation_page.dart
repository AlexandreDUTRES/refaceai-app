import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/pages/generation/generation_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/bloc_manager/generation_builder.dart';
import 'package:photogenerator/ui/bloc_manager/models_builder.dart';
import 'package:photogenerator/ui/widgets/model_preview.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:photogenerator/ui/widgets/static_grid.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:styled_widget/styled_widget.dart';

// ignore: must_be_immutable
class GenerationPage extends StatelessWidget {
  late GenerationPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildGenerationImage(Generation generation) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          decoration: BoxDecoration(
            color: _appTheme.palette.secondaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Stack(
            children: [
              PinchZoom(
                maxScale: 5,
                child: CachedNetworkImage(
                  imageUrl: generation.url,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 6.sp,
                right: 6.sp,
                child: Text(
                  tr("pages.generation.txt_reuse_model"),
                  style: _appTheme.fonts.xsBody.bold.style.copyWith(
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                )
                    .padding(
                      horizontal: 8.sp,
                      vertical: 6.sp,
                    )
                    .decorated(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(50.sp),
                    )
                    .gestures(
                      onTap: bloc.goToModelPage,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: () async => await bloc.share(),
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
              Icons.share,
              size: 25.sp,
              color: _appTheme.palette.textColor,
            ),
            Padding(padding: EdgeInsets.only(left: 8.sp)),
            Text(
              tr("globals.share"),
              style: _appTheme.fonts.xsTitle.bold.style,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButtons(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async => await bloc.locallySaveImage(),
          child: Container(
            padding: EdgeInsets.all(10.sp),
            color: Colors.transparent,
            child: Icon(
              Icons.download_outlined,
              color: _appTheme.palette.textColor,
              size: 25.sp,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async => await bloc.goToDeleteGenerationModal(),
          child: Container(
            padding: EdgeInsets.all(10.sp),
            color: Colors.transparent,
            child: Icon(
              Icons.delete_outline,
              size: 25.sp,
              color: _appTheme.palette.textColor,
            ),
          ),
        ).padding(right: 10.sp),
      ],
    );
  }

  Widget _buildReviewEmoji({
    required CustomPngs icon,
    required void Function() onTap,
  }) {
    return icon
        .build(
          width: 30.sp,
          height: 30.sp,
        )
        .padding(all: 5.sp)
        .backgroundColor(Colors.transparent)
        .gestures(onTap: onTap);
  }

  Widget _buildReviewCard() {
    return Column(
      children: [
        Text(
          tr("pages.generation.txt_review"),
          style: _appTheme.fonts.sBody.bold.style,
          textAlign: TextAlign.start,
        ),
        Padding(padding: EdgeInsets.only(top: 10.sp)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildReviewEmoji(
              icon: CustomPngs.others__smiley_very_dissatisfied,
              onTap: () => bloc.review(1),
            ),
            _buildReviewEmoji(
              icon: CustomPngs.others__smiley_dissatisfied,
              onTap: () => bloc.review(2),
            ),
            _buildReviewEmoji(
              icon: CustomPngs.others__smiley_neutral,
              onTap: () => bloc.review(3),
            ),
            _buildReviewEmoji(
              icon: CustomPngs.others__smiley_satisfied,
              onTap: () => bloc.review(4),
            ),
            _buildReviewEmoji(
              icon: CustomPngs.others__smiley_very_satisfied,
              onTap: () => bloc.review(5),
            ),
          ],
        ),
      ],
    )
        .padding(horizontal: 16.sp, vertical: 10.sp)
        .decorated(
          border: Border.all(color: _appTheme.palette.secondaryColor),
          borderRadius: BorderRadius.circular(15.sp),
        )
        .padding(horizontal: 16.sp, bottom: 10.sp);
  }

  Widget _buildModelsList(List<Model> models) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 10.sp)),
          Text(
            tr("pages.generation.txt_title_models"),
            style: _appTheme.fonts.xsTitle.bold.style,
          ).padding(horizontal: 16.sp, bottom: 10.sp),
          StaticGrid(
            columnCount: 3,
            verticalGap: 8.sp,
            horizontalGap: 8.sp,
            children: models
                .map(
                  (model) => LayoutBuilder(
                    builder: (context, constraints) => ModelPreview(
                      model: model,
                      width: constraints.maxWidth,
                      onTap: () async => await Common.goToModelPage(model),
                    ),
                  ),
                )
                .toList(),
          ).padding(horizontal: 16.sp),
        ],
      ),
    );
  }

  Widget _buildGenerationPage({
    required BoxConstraints constraints,
    required Generation generation,
    required int index,
  }) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageTopBar(
              backButton: true,
              title: tr("globals.back"),
              additionalWidget: _buildTopButtons(index),
            ),
            _buildGenerationImage(generation),
            Padding(padding: EdgeInsets.only(top: 15.sp)),
            _buildShareButton(),
            Padding(padding: EdgeInsets.only(top: 20.sp)),
            GenerationBuilder(
              (Generation g) =>
                  g.rating == null ? _buildReviewCard() : SizedBox(),
              generationId: generation.id,
            ),
            ModelsBuilder(
              (categories) => _buildModelsList(categories.first.models),
              promptId: generation.promptId,
            ),
            Padding(padding: EdgeInsets.only(top: 20.sp)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerationPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
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
            itemCount: bloc.generations.length,
            preloadPagesCount: min(3, bloc.generations.length),
            itemBuilder: (context, i) {
              return _buildGenerationPage(
                constraints: constraints,
                generation: bloc.generations[i],
                index: i,
              );
            },
            onPageChanged: (i) => bloc.setIndex(i),
          ),
        );
      },
    );
  }
}
