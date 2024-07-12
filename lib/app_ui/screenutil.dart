library screenutil;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SizerHandler {
  static late double statusBarHeight;
  static late double bottomBarHeight;

  static double get pixelRatio => Device.pixelRatio;
  static double get aspectRatio => Device.aspectRatio;
  static double get screenWidth => Device.width;
  static double get screenHeight => Device.height;

  static ResponsiveSizer init({
    required BuildContext context,
    required Widget Function(BuildContext, Orientation, ScreenType) builder,
  }) {
    statusBarHeight = MediaQuery.of(context).viewPadding.top;
    bottomBarHeight = MediaQuery.of(context).viewPadding.bottom;

    return ResponsiveSizer(
      builder: builder,
    );
  }
}

extension SizeExtension on num {
  // Size get _uiSize => const Size(360, 360);
  Size get _uiSize => const Size(360, 690);

  double get scaleWidth => SizerHandler.screenWidth / _uiSize.width;
  double get scaleHeight => SizerHandler.screenHeight / _uiSize.height;
  // double get scaleText => scaleWidth;

  double get w => this * scaleWidth;
  double get h => this * scaleHeight;

  double get r => this * min(scaleWidth, scaleHeight);
  double get sp => this * min(scaleWidth, scaleHeight);

  double get sw => SizerHandler.screenWidth * this;
  double get sh => SizerHandler.screenHeight * this;
}