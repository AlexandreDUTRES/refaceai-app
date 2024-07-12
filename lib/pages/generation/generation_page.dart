import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/pages/generation/generation_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:preload_page_view/preload_page_view.dart';

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
            color: _appTheme.palette.secondaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: PinchZoom(
            maxScale: 5,
            child: CachedNetworkImage(
              imageUrl: generation.url,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveContainer(bool isLocallySaved) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap:
            isLocallySaved ? null : () async => await bloc.locallySaveImage(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
          decoration: BoxDecoration(
            color: _appTheme.palette.textColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLocallySaved
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: _appTheme.palette.textColor,
                      size: 18.sp,
                    )
                  : Icon(
                      Icons.download_for_offline_rounded,
                      color: _appTheme.palette.textColor,
                      size: 18.sp,
                    ),
              Padding(padding: EdgeInsets.only(left: 8.sp)),
              Padding(
                padding: EdgeInsets.only(bottom: 2.sp),
                child: isLocallySaved
                    ? Text(
                        "Enregistré dans la galerie",
                        style: _appTheme.fonts.sBody.bold.style,
                      )
                    : Text(
                        "Télécharger dans la galerie",
                        style: _appTheme.fonts.sBody.bold.style,
                      ),
              ),
              Padding(padding: EdgeInsets.only(left: 5.sp)),
            ],
          ),
        ),
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
          onPressed: () async => await bloc.share(),
          style: _appTheme.buttons.mainElevated.style,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share,
                  size: 20.sp,
                  color: _appTheme.palette.textColor,
                ),
                Padding(padding: EdgeInsets.only(left: 8.sp)),
                Text("Partager"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () async => await bloc.goToDeleteGenerationModal(),
      child: Container(
        padding: EdgeInsets.only(
          top: 8.sp,
          bottom: 8.sp,
          right: 14.sp,
          left: 8.sp,
        ),
        color: Colors.transparent,
        child: Icon(
          Icons.delete_outline,
          size: 25.sp,
          color: _appTheme.palette.textColor,
        ),
      ),
    );
  }

  Widget _buildGenerationPage({
    required BoxConstraints constraints,
    required AsyncSnapshot<GenerationPageData> snapshot,
    required Generation generation,
    required int index,
  }) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: SizerHandler.statusBarHeight),
          ),
          PageTopBar(
            backButton: true,
            title: "Retour",
            additionalWidget: _buildDeleteButton(),
          ),
          Padding(padding: EdgeInsets.only(top: 35.sp)),
          _buildGenerationImage(generation),
          Padding(padding: EdgeInsets.only(top: 15.sp)),
          _buildSaveContainer(snapshot.data!.isLocallySaved[index]),
          Padding(padding: EdgeInsets.only(top: 50.sp)),
          Expanded(child: Container()),
          _buildPhotoButton(),
          Padding(padding: EdgeInsets.only(top: 15.sp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerationPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      enableScroll: false,
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (BuildContext context, BoxConstraints constraints) {
        return StreamBuilder<GenerationPageData>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return PreloadPageView.builder(
              controller: bloc.preloadPageController,
              itemCount: bloc.generations.length,
              preloadPagesCount: min(3, bloc.generations.length),
              itemBuilder: (context, i) {
                return _buildGenerationPage(
                  constraints: constraints,
                  snapshot: snapshot,
                  generation: bloc.generations[i],
                  index: i,
                );
              },
              onPageChanged: (i) => bloc.setIndex(i),
            );
          },
        );
      },
    );
  }
}
