// ignore_for_file: sized_box_for_whitespace

library bottom_modal_layout;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/keyboard_handler_utils/widgets/responsive_keyboard_sized_container.dart';
import 'package:photogenerator/ui/widgets/measure_size_render_object.dart';
import 'package:photogenerator/ui/widgets/no_glowing_overscroll_changer.dart';

class BottomModalLayout extends StatefulWidget {
  const BottomModalLayout({
    Key? key,
    required this.content,
    required this.backgroundColor,
  }) : super(key: key);

  final Widget content;
  final Color backgroundColor;

  @override
  _BottomModalLayoutState createState() => _BottomModalLayoutState();
}

class _BottomModalLayoutState extends State<BottomModalLayout> {
  late AppThemeV2 _appTheme;

  final ScrollController _scrollController = ScrollController();

  double? _parentHeight;
  final double _scrollOffset = 25;

  void _setFocusWidgetVisible(double keyboardHeight) {
    if (_parentHeight == null) return;
    // check if element is the top level widget
    final _isTopOfNavigationStack = ModalRoute.of(context)?.isCurrent ?? false;
    if (!_isTopOfNavigationStack) return;

    if (FocusManager.instance.primaryFocus == null ||
        FocusManager.instance.primaryFocus is FocusScopeNode) return;
    double distanceFromBottomScreen;
    try {
      distanceFromBottomScreen = _parentHeight! -
          FocusManager.instance.primaryFocus!.offset.dy -
          FocusManager.instance.primaryFocus!.size.height;
    } catch (e) {
      return;
    }

    // check if focus widget is visible
    if (distanceFromBottomScreen > keyboardHeight + _scrollOffset) return;

    double requiredScrollOffset = _scrollController.offset +
        (keyboardHeight + _scrollOffset - distanceFromBottomScreen);
    _scrollController.jumpTo(requiredScrollOffset);
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppThemeV2.of(context);
    return MeasureSize(
      onChange: (size) {
        if (size.height == 0) return;
        _parentHeight = size.height;
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(56.sp),
            topRight: Radius.circular(56.sp),
          ),
        ),
        child: NoGlowingOverscrollChanger(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 34.sp,
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56.sp,
                        height: 5.sp,
                        decoration: BoxDecoration(
                          color: _appTheme.palette.textColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.content,
                MeasureSize(
                  onChange: (size) {
                    if (size.height == 0) return;
                    _setFocusWidgetVisible(size.height);
                  },
                  child: const ResponsiveKeyboardSizedContainer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
