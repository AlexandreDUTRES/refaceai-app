library main_scroller;

import 'package:flutter/material.dart';
import 'package:photogenerator/keyboard_handler_utils/widgets/responsive_keyboard_sized_container.dart';
import 'package:photogenerator/ui/widgets/measure_size_render_object.dart';
import 'package:photogenerator/ui/widgets/no_glowing_overscroll_changer.dart';

class MainScroller extends StatefulWidget {
  const MainScroller({
    Key? key,
    required this.child,
    this.controller,
    required this.parentHeight,
    this.height,
    this.endingScrollCallback,
  }) : super(key: key);

  final Widget child;
  final ScrollController? controller;
  final double parentHeight;
  final double? height;
  final Function()? endingScrollCallback;

  @override
  _MainScrollerState createState() => _MainScrollerState();
}

class _MainScrollerState extends State<MainScroller> {
  final double _scrollOffset = 25;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    if (widget.endingScrollCallback == null) return;
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    double scrollPosition = _controller.position.pixels;
    if (_controller.position.maxScrollExtent - scrollPosition < 10) {
      widget.endingScrollCallback!();
    }
  }

  void _setFocusWidgetVisible(double keyboardHeight) {
    // check if element is the top level widget
    final _isTopOfNavigationStack = ModalRoute.of(context)?.isCurrent ?? false;
    if (!_isTopOfNavigationStack) return;

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

    double requiredScrollOffset = _controller.offset +
        (keyboardHeight + _scrollOffset - distanceFromBottomScreen);
    _controller.jumpTo(requiredScrollOffset);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NoGlowingOverscrollChanger(
            child: SingleChildScrollView(
              controller: _controller,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: widget.height,
                width: double.infinity,
                child: widget.child,
              ),
            ),
          ),
        ),
        MeasureSize(
          onChange: (size) {
            if (size.height == 0) return;
            _setFocusWidgetVisible(size.height);
          },
          child: const ResponsiveKeyboardSizedContainer(),
        ),
      ],
    );
  }
}
