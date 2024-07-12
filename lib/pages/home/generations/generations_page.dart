import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/home/generations/generations_page_bloc.dart';
import 'package:photogenerator/ui/bloc_manager/generations_builder.dart';
import 'package:photogenerator/ui/widgets/main_scroller.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:photogenerator/utils/Common.dart';

// ignore: must_be_immutable
class GenerationsPage extends StatelessWidget {
  late GenerationsPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildNoImagesText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      child: GestureDetector(
        onTap: () async => await bloc.goToModelsPage(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
          decoration: BoxDecoration(
            gradient: _appTheme.palette.primaryGradient,
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  tr("pages.home.generations.txt_no_elements"),
                  style: _appTheme.fonts.sBody.semibold.style,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5.sp)),
              Icon(
                Icons.arrow_forward,
                size: 30.sp,
                color: _appTheme.palette.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenerationContainer({
    required double width,
    required Generation generation,
    required List<Generation> generations,
  }) {
    return GestureDetector(
      onTap: () async => await Common.goToGenerationPage(generation),
      child: Container(
        height: width,
        width: width,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: _appTheme.palette.secondaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: CachedNetworkImage(
          imageUrl: generation.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGenerationsList(
    AsyncSnapshot<GenerationsPageData> snapshot,
    List<Generation> generations,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) => Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 8.sp,
          children: generations
              .sublist(0, min(generations.length, snapshot.data!.displayCnt))
              .map(
                (generation) => _buildGenerationContainer(
                  width: (constraints.maxWidth / 2) - 4.sp,
                  generation: generation,
                  generations: generations,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerationsPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return StreamBuilder<GenerationsPageData>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return LayoutBuilder(
          builder: (context, constraints) => MainScroller(
            parentHeight: constraints.maxHeight,
            endingScrollCallback: bloc.endingScrollCallback,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizerHandler.statusBarHeight),
                ),
                PageTopBar(
                  backButton: false,
                  title: tr("pages.home.generations.txt_title"),
                ),
                GenerationsBuilder(
                  (generations) => generations.isNotEmpty
                      ? _buildGenerationsList(snapshot, generations)
                      : _buildNoImagesText(),
                ),
                Padding(padding: EdgeInsets.only(top: 15.sp)),
              ],
            ),
          ),
        );
      },
    );
  }
}
