library no_glowing_overscroll_changer;

import 'package:flutter/material.dart';

class NoGlowingOverscrollChanger extends StatelessWidget {
  final Widget child;
  final bool showLeading;
  final bool showTrailing;

  const NoGlowingOverscrollChanger({
    Key? key,
    required this.child,
    this.showLeading = false,
    this.showTrailing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: SpecifiableOverscrollColorScrollBehavior(
        showLeading: showLeading,
        showTrailing: showTrailing,
      ),
      child: child,
    );
  }
}

class SpecifiableOverscrollColorScrollBehavior extends ScrollBehavior {
  final Color overscrollColor;
  final bool showLeading;
  final bool showTrailing;

  const SpecifiableOverscrollColorScrollBehavior({
    this.overscrollColor = Colors.transparent,
    required this.showLeading,
    required this.showTrailing,
  });

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return GlowingOverscrollIndicator(
      child: child,
      axisDirection: details.direction,
      color: Colors.transparent,
      showLeading: showLeading,
      showTrailing: showTrailing,
    );
  }
}
