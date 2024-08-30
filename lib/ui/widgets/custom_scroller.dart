import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';

import '../../keyboard_handler_utils/widgets/responsive_keyboard_sized_container.dart';
import 'measure_size_render_object.dart';
import 'no_glowing_overscroll_changer.dart';

class CustomScroller extends StatefulWidget {
  const CustomScroller({
    super.key,
    required this.child,
    this.controller,
    required this.parentHeight,
    this.height,
  });

  final Widget child;
  final ScrollController? controller;
  final double parentHeight;
  final double? height;

  @override
  CustomScrollerState createState() => CustomScrollerState();
}

class CustomScrollerState extends State<CustomScroller> {
  final double _scrollOffset = 100.sp;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setFocusWidgetVisible(double keyboardHeight) {
    // check if element is the top level widget
    final bool isTopOfNavigationStack =
        ModalRoute.of(context)?.isCurrent ?? false;
    if (!isTopOfNavigationStack) return;

    if (FocusManager.instance.primaryFocus == null ||
        FocusManager.instance.primaryFocus is FocusScopeNode) return;
    double distanceFromBottomScreen;
    try {
      distanceFromBottomScreen = widget.parentHeight -
          FocusManager.instance.primaryFocus!.offset.dy -
          FocusManager.instance.primaryFocus!.size.height;
    } catch (e) {
      return;
    }

    // check if focus widget is visible
    if (distanceFromBottomScreen > keyboardHeight + _scrollOffset) return;

    final double requiredScrollOffset = _controller.offset +
        (keyboardHeight + _scrollOffset - distanceFromBottomScreen);
    _controller.jumpTo(requiredScrollOffset);
  }

  Widget _buildScrollParent(Widget child) {
    return SingleChildScrollView(
      controller: _controller,
      physics: const ClampingScrollPhysics(),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: NoGlowingOverscrollChanger(
            child: _buildScrollParent(
              SizedBox(
                height: widget.height,
                width: double.infinity,
                child: widget.child,
              ),
            ),
          ),
        ),
        MeasureSize(
          onChange: (Size size) {
            if (size.height == 0) return;
            _setFocusWidgetVisible(size.height);
          },
          child: const ResponsiveKeyboardSizedContainer(),
        ),
      ],
    );
  }
}
