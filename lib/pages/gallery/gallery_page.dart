import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/pages/gallery/gallery_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/bloc_manager/gallery_builder.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:styled_widget/styled_widget.dart';

// ignore: must_be_immutable
class GalleryPage extends StatelessWidget {
  late GalleryPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildCell({
    required double width,
    required Widget child,
    required Function() onTap,
     Function()? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: width,
        width: width,
        child: child,
      ),
    );
  }

  Widget _buildCameraContainer(double width) {
    return _buildCell(
      width: width,
      onTap: () async => await bloc.openCameraPage(),
      child: Container(
        color: _appTheme.palette.primaryColor,
        child: Icon(
          Icons.camera_alt_rounded,
          size: width / 2,
          color: _appTheme.palette.textColor,
        ),
      ),
    );
  }

  Widget _buildImportContainer(double width) {
    return _buildCell(
      width: width,
      onTap: () async => await bloc.openFilePicker(_appTheme),
      child: Container(
        color: _appTheme.palette.secondaryColor,
        child: Icon(
          Icons.add,
          size: width / 2,
          color: _appTheme.palette.textColor,
        ),
      ),
    );
  }

  Widget _buildFileContainer(double width, File file) {
    return _buildCell(
      width: width,
      onTap: () async => await bloc.selectMedia(file),
      onLongPress: () async => await bloc.goToDeleteGalleryImageModal(file),
      child: Image.file(
        file,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildList() {
    return GalleryBuilder(
      (files) {
        List<Widget Function(double)> widgetBuilders = [
          _buildCameraContainer,
          _buildImportContainer
        ];
        for (File file in files) {
          widgetBuilders.add((w) => _buildFileContainer(w, file));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) => Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 4.sp,
              spacing: 4.sp,
              children: widgetBuilders
                  .map(
                    (b) => b((constraints.maxWidth / 3) - 3.sp),
                  )
                  .toList(),
            ),
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GalleryPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    final ScrollController customScrollController = ScrollController();

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return SingleChildScrollView(
          controller: customScrollController,
          child: Column(
            children: [
              PageTopBar(
                backButton: true,
                title: tr("pages.gallery.txt_title"),
              ).padding(top: topPadding),
              Column(
                children: [
                  _buildInfoText(
                    title: tr("pages.gallery.txt_info_1_title"),
                    description: tr("pages.gallery.txt_info_1_description"),
                    iconData: Icons.check,
                    iconColor: Colors.blue[800]!,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.sp)),
                  _buildInfoText(
                    title: tr("pages.gallery.txt_info_2_title"),
                    description: tr("pages.gallery.txt_info_2_description"),
                    iconData: Icons.close,
                    iconColor: Colors.red[800]!,
                  ),
                ],
              )
                  .padding(horizontal: 12.sp, vertical: 14.sp)
                  .decorated(
                    border: Border.all(color: _appTheme.palette.secondaryColor),
                    borderRadius: BorderRadius.circular(10.sp),
                  )
                  .padding(horizontal: 16.sp, bottom: 10.sp),
              _buildList(),
              Padding(padding: EdgeInsets.only(top: bottomPadding + 15.sp)),
            ],
          ),
        );
      },
    );
  }
}
