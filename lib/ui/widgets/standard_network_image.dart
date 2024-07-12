library standard_network_image;

import 'dart:math';

import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photogenerator/ui/widgets/loader.dart';

// ignore: must_be_immutable
class StandardNetworkImage extends StatelessWidget {
  late AppThemeV2 _appTheme;

  StandardNetworkImage({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.border,
    this.borderRadius,
    this.fit = BoxFit.contain,
    this.svgColor,
  }) : super(key: key);

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxShape shape;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final Color? svgColor;

  bool _isSvgImage(String image) {
    return image.endsWith(".svg");
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppThemeV2.of(context);

    Color _svgColor = svgColor ?? _appTheme.palette.primaryColor;

    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: border,
        shape: shape,
        borderRadius: borderRadius,
      ),
      child: !_isSvgImage(imageUrl)
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              fadeInDuration: const Duration(milliseconds: 100),
              fadeOutDuration: const Duration(milliseconds: 100),
              placeholder: (context, url) =>
                  LayoutBuilder(builder: (context, constraints) {
                double maxLoaderSize =
                    min(constraints.maxHeight, constraints.maxWidth) / 2;
                return Center(
                  child: Loader(
                    size: maxLoaderSize < 20.sp ? maxLoaderSize : 20.sp,
                    color: _appTheme.palette.primaryColor,
                  ),
                );
              }),
            )
          : SvgPicture.network(
              imageUrl,
              fit: fit,
              // ignore: deprecated_member_use
              color: _svgColor,
            ),
    );
  }
}
