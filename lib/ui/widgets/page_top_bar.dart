import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

// ignore: must_be_immutable
class PageTopBar extends StatelessWidget {
  late AppThemeV2 _appTheme;

  PageTopBar({
    Key? key,
    required this.backButton,
    required this.title,
    this.additionalWidget,
    this.decorationImage,
    this.innerBottomPadding,
  }) : super(key: key);

  final bool backButton;
  final String? title;
  final Widget? additionalWidget;
  final DecorationImage? decorationImage;
  final double? innerBottomPadding;

  @override
  Widget build(BuildContext context) {
    _appTheme = AppThemeV2.of(context);

    return Container(
      height: 68.sp - (innerBottomPadding ?? 0),
      padding: EdgeInsets.symmetric(vertical: (innerBottomPadding ?? 0) / 2),
      width: double.infinity,
      decoration: BoxDecoration(
        image: decorationImage,
      ),
      child: Row(
        children: [
          backButton
              ? GestureDetector(
                  onTap: () async => await GlobalNavigator().pop(),
                  child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: _appTheme.palette.textColor,
                      size: 20.sp,
                    ),
                  ),
                )
              : Container(
                  width: 16.sp,
                  height: 40.sp,
                ),
          title != null
              ? GestureDetector(
                  onTap: backButton
                      ? () async => await GlobalNavigator().pop()
                      : null,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 5.sp),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title!,
                      style: _appTheme.fonts.sTitle.semibold.style.copyWith(
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withValues(alpha:0.3),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : Container(),
          Expanded(child: Container()),
          if (additionalWidget != null) additionalWidget!,
        ],
      ),
    );
  }
}
