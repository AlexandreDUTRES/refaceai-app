// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../../app_ui/screenutil.dart';
import 'custom_scroller.dart';
import 'measure_size_render_object.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({
    super.key,
    required this.bodyBuilder,
    required this.backgroundColor,
    this.removeTopBannerPadding = false,
    this.simpleTitle,
    this.additionalTitleWidget,
    this.showSimpleBackButton = false,
    this.showSimpleCloseButton = false,
    this.bottomStickyWidget,
    this.floatingActionButton,
    this.floatingActionButtonPadding,
    this.canPop = true,
    this.onPopInvoked,
    this.mainScrollController,
  });

  final Widget Function(
    BuildContext,
    BoxConstraints,
    double,
    double,
  ) bodyBuilder;

  final String? simpleTitle;
  final Widget? additionalTitleWidget;
  final bool showSimpleBackButton;
  final bool showSimpleCloseButton;
  final Widget? bottomStickyWidget;
  final Color backgroundColor;
  final bool removeTopBannerPadding;
  final Widget? floatingActionButton;
  final double? floatingActionButtonPadding;
  final bool canPop;
  final void Function(bool)? onPopInvoked;
  final ScrollController? mainScrollController;

  @override
  PageLayoutState createState() => PageLayoutState();
}

class PageLayoutState extends State<PageLayout> {
  double _floationgContainerHeight = 0;
  double _bottomStickyWidgetHeight = 0;

  void _setFloationgContainerHeight(double v) {
    if (!mounted) return;
    setState(() {
      _floationgContainerHeight = v;
    });
  }

  void _setBottomStickyWidgetHeight(double v) {
    if (!mounted) return;
    setState(() {
      _bottomStickyWidgetHeight = v;
    });
  }

  Widget _buildAutoInputScrollContainer(
    BoxConstraints parentConstraints,
    Widget child,
  ) {
    return CustomScroller(
      parentHeight: parentConstraints.maxHeight,
      child: SizedBox(
        width: parentConstraints.maxWidth,
        height: parentConstraints.maxHeight,
        child: child,
      ),
    );
  }

  Widget _buildScroller() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            _buildAutoInputScrollContainer(
              constraints,
              widget.bodyBuilder(
                context,
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                ),
                !widget.removeTopBannerPadding
                    ? SizerHandler.statusBarHeight
                    : 0,
                _floationgContainerHeight + _bottomStickyWidgetHeight,
              ),
            ),
            if (widget.bottomStickyWidget != null)
              Positioned(
                bottom: 0,
                left: 0,
                child: MeasureSize(
                  onChange: (Size s) => _setBottomStickyWidgetHeight(s.height),
                  child: widget.bottomStickyWidget!,
                ),
              ),
            _buildFloatingContainer(),
          ],
        );
      },
    );
  }

  Widget _buildFloatingContainer() {
    if (widget.floatingActionButton == null) {
      return Container();
    }
    final double bottom = widget.floatingActionButtonPadding ?? 10.sp;

    return Positioned(
      bottom: bottom,
      left: 0,
      child: Container(
        width: 1.sw,
        child: MeasureSize(
          onChange: (Size s) {
            _setFloationgContainerHeight(s.height + bottom);
          },
          child: widget.floatingActionButton!,
        ),
      ),
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
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: false,
            // appBar: widget.appBarConfiguration != null
            //     ? CustomAppBar(
            //         title: widget.appBarConfiguration!.title,
            //         showBackButton: widget.appBarConfiguration!.showBackButton,
            //         progress: widget.appBarConfiguration!.progress,
            //       )
            //     : null,
            body: _buildScroller(),
          ),
        ),
      ),
    );
  }
}
