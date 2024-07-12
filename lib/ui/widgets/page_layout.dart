library mic_button;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/ui/widgets/main_scroller.dart';
import 'package:photogenerator/ui/widgets/measure_size_render_object.dart';

// ignore: must_be_immutable
class PageLayout extends StatefulWidget {
  PageLayout({
    Key? key,
    required this.bodyBuilder,
    this.enableScroll = false,
    this.backgroundColor,
    this.backgroundGradient,
    this.bottomStickyWidget,
    this.canPop = true,
    this.onPopInvoked,
  }) : super(key: key);

  final Widget Function(BuildContext, BoxConstraints) bodyBuilder;
  final bool enableScroll;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Widget? bottomStickyWidget;
  final bool canPop;
  final void Function(bool)? onPopInvoked;

  @override
  PageLayoutState createState() => PageLayoutState();
}

class PageLayoutState extends State<PageLayout> {
  double _bottomStickyWidgetHeight = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setBottomStickyWidgetHeight(double v) {
    if (!mounted) return;
    setState(() {
      _bottomStickyWidgetHeight = v;
    });
  }

  Widget _buildBody(double width) {
    if (widget.enableScroll) {
      return widget.bodyBuilder(
        context,
        BoxConstraints(
          maxWidth: width,
          maxHeight: double.infinity,
        ),
      );
    } else {
      return Flexible(
        child: LayoutBuilder(
          builder: (context, constraints) => widget.bodyBuilder(
            context,
            BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildScroller() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                gradient: widget.backgroundGradient,
              ),
              child: MainScroller(
                parentHeight: constraints.maxHeight,
                height: widget.enableScroll ? null : constraints.maxHeight,
                child: Column(
                  children: [
                    _buildBody(constraints.maxWidth),
                    Padding(
                      padding: EdgeInsets.only(top: _bottomStickyWidgetHeight),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.bottomStickyWidget != null)
              Positioned(
                bottom: 0,
                left: 0,
                child: MeasureSize(
                  onChange: (s) => _setBottomStickyWidgetHeight(s.height),
                  child: widget.bottomStickyWidget!,
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: PopScope(
          canPop: widget.canPop,
          onPopInvoked: widget.onPopInvoked,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: _buildScroller(),
          ),
        ),
      ),
    );
  }
}
